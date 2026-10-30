#!/usr/bin/env python3
"""HTTP publish endpoint for a static site.

The service never learns which hostname it is published under: every URL it
prints (docs, publish responses) is derived from the request's own Host header,
so the address lives only in the reverse proxy config.

Threat model: whoever holds the bearer token may upload **static files only**.
Nothing uploaded is ever executed -- caddy serves the published tree with
file_server, so the worst case is ugly HTML on a dedicated hostname.

Layout under RH_SITE_ROOT:
    releases/<stamp>[-<label>]/   immutable tree of one upload
    current -> releases/<stamp>   atomic symlink, this is what caddy serves
    state/token                   bearer token (auto-generated on first start)
    state/<stamp>.json            metadata of one release

Only cpython's stdlib is used; the unit runs unprivileged with a read-only
filesystem apart from RH_SITE_ROOT.
"""

import hmac
import json
import os
import re
import secrets
import shutil
import sys
import tarfile
import threading
import time
import uuid
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import parse_qs, urlparse

SITE_ROOT = os.environ.get("RH_SITE_ROOT", "/data/www/rhcg")
RELEASES = os.path.join(SITE_ROOT, "releases")
CURRENT = os.path.join(SITE_ROOT, "current")
STATE = os.path.join(SITE_ROOT, "state")
TOKEN_FILE = os.environ.get("RH_TOKEN_FILE", os.path.join(STATE, "token"))
DOCS_FILE = os.environ.get("RH_DOCS_FILE", "")
BIND = os.environ.get("RH_BIND", "127.0.0.1")
PORT = int(os.environ.get("RH_PORT", "18778"))

MAX_UPLOAD = int(os.environ.get("RH_MAX_UPLOAD_MB", "200")) * 1024 * 1024
MAX_UNPACKED = int(os.environ.get("RH_MAX_UNPACKED_MB", "400")) * 1024 * 1024
MAX_FILES = int(os.environ.get("RH_MAX_FILES", "5000"))
KEEP_RELEASES = int(os.environ.get("RH_KEEP_RELEASES", "8"))

PUBLISH_LOCK = threading.Lock()

# Host header is attacker-controlled and ends up in the rendered docs: keep it to
# characters a host:port can legally contain.
HOST_RE = re.compile(r"^[A-Za-z0-9._:\[\]-]{1,253}$")

PLACEHOLDER = """<!doctype html>
<html lang="zh-CN">
<meta charset="utf-8">
<title>Site not deployed yet</title>
<style>
  html { font: 16px/1.7 system-ui, sans-serif; background: #12161c; color: #d8dee9; }
  body { max-width: 40rem; margin: 15vh auto; padding: 0 1.5rem; }
  code { background: #1c232d; padding: .1em .4em; border-radius: 3px; }
</style>
<h1>Site not deployed yet</h1>
<p>This host is waiting for its first upload.</p>
<p>Machine-readable publishing instructions: <code>/__publish/docs</code></p>
"""


class Fail(Exception):
    """Rejection with a message meant for the uploading agent."""

    def __init__(self, code, message, **extra):
        super().__init__(message)
        self.code = code
        self.message = message
        self.extra = extra


def log(msg):
    sys.stderr.write("[rhcg-site] %s\n" % msg)
    sys.stderr.flush()


def load_or_create_token():
    try:
        with open(TOKEN_FILE, "r", encoding="utf-8") as fh:
            token = fh.read().strip()
        if token:
            return token
    except FileNotFoundError:
        pass
    token = secrets.token_urlsafe(32)
    os.makedirs(os.path.dirname(TOKEN_FILE), mode=0o750, exist_ok=True)
    tmp = TOKEN_FILE + ".tmp"
    try:
        fd = os.open(tmp, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
        with os.fdopen(fd, "w", encoding="utf-8") as fh:
            fh.write(token + "\n")
        os.replace(tmp, TOKEN_FILE)
    except OSError as exc:
        raise SystemExit(
            "cannot create token at %s (%s); provide one there or via RH_TOKEN_FILE"
            % (TOKEN_FILE, exc)
        ) from exc
    log("generated new token at %s" % TOKEN_FILE)
    return token


def current_release():
    try:
        target = os.readlink(CURRENT)
    except OSError:
        return None
    name = os.path.basename(target.rstrip("/"))
    return name if os.path.isdir(os.path.join(RELEASES, name)) else None


def list_releases():
    try:
        names = os.listdir(RELEASES)
    except FileNotFoundError:
        return []
    out = []
    for name in names:
        path = os.path.join(RELEASES, name)
        if name.startswith(".") or not os.path.isdir(path):
            continue
        meta = {"release": name, "created": int(os.path.getmtime(path))}
        try:
            with open(os.path.join(STATE, name + ".json"), "r", encoding="utf-8") as fh:
                meta.update(json.load(fh))
        except (OSError, ValueError):
            pass
        out.append(meta)
    out.sort(key=lambda r: r["created"], reverse=True)
    return out


def save_meta(name, **fields):
    try:
        with open(os.path.join(STATE, name + ".json"), "w", encoding="utf-8") as fh:
            json.dump(fields, fh, ensure_ascii=False)
    except OSError:
        pass


def prune_releases():
    releases = [
        d
        for d in os.listdir(RELEASES)
        if not d.startswith(".") and os.path.isdir(os.path.join(RELEASES, d))
    ]
    releases.sort(key=lambda d: os.path.getmtime(os.path.join(RELEASES, d)), reverse=True)
    keep = set(releases[:KEEP_RELEASES])
    keep.add(current_release())
    for name in releases:
        if name not in keep:
            log("pruning release %s" % name)
            shutil.rmtree(os.path.join(RELEASES, name), ignore_errors=True)
            try:
                os.unlink(os.path.join(STATE, name + ".json"))
            except OSError:
                pass


def switch_current(name):
    if not name or "/" in name or name.startswith(".") or name in (".", ".."):
        raise Fail(400, "invalid release name: %r" % name)
    target = os.path.join("releases", name)
    if not os.path.isdir(os.path.join(RELEASES, name)):
        raise Fail(404, "release %r does not exist" % name)
    tmp = os.path.join(SITE_ROOT, ".current.tmp-%s" % uuid.uuid4().hex[:8])
    os.symlink(target, tmp)
    os.replace(tmp, CURRENT)


def normalize_member_name(raw):
    name = raw.replace("\\", "/")
    while name.startswith("./"):
        name = name[2:]
    while name.endswith("/"):
        name = name[:-1]
    if not name or name == ".":
        return None
    if name.startswith("/") or name == ".." or name.startswith("../"):
        raise Fail(400, "path must stay inside the site: %r" % raw)
    parts = name.split("/")
    if any(part in ("", ".", "..") for part in parts):
        raise Fail(400, "non-canonical path: %r" % raw)
    if len(name) > 400:
        raise Fail(400, "path is too long: %r" % raw[:80])
    return name


def plan_archive(tf):
    """Validate the archive and return (members, prefix_to_strip).

    A single wrapping directory (the classic `tar czf site.tar.gz site/`) is
    stripped so that the uploaded tree lands at the site root.
    """
    members = []
    total = 0
    # 用 next() 增量读而不是 getmembers()：巨大归档里的海量头部不会把内存吃光，
    # 一旦超过条目上限就提前停下来。
    while True:
        member = tf.next()
        if member is None:
            break
        if len(members) >= MAX_FILES:
            raise Fail(413, "too many entries (limit %d)" % MAX_FILES)
        if member.isdir():
            name = normalize_member_name(member.name)
            if name:
                members.append((member, name))
            continue
        if not member.isfile():
            raise Fail(
                400,
                "only regular files and directories are accepted, %r is a %s"
                % (member.name, "symlink" if member.issym() else "special file"),
            )
        name = normalize_member_name(member.name)
        if name is None:
            continue
        if member.size < 0:
            raise Fail(400, "negative size for %r" % member.name)
        total += member.size
        if total > MAX_UNPACKED:
            raise Fail(
                413,
                "unpacked size exceeds %d MB" % (MAX_UNPACKED // 1024 // 1024),
            )
        members.append((member, name))
    if not members:
        raise Fail(400, "tar is empty")

    names = {name for _, name in members}
    prefix = ""
    if "index.html" not in names:
        tops = {name.split("/", 1)[0] for name in names}
        if len(tops) == 1:
            top = next(iter(tops))
            if ("%s/index.html" % top) in names:
                prefix = top + "/"
    if not prefix and not ({"index.html", "index.htm"} & names):
        hint = sorted(names)[:5]
        raise Fail(
            400,
            "index.html is missing at the archive root (first entries: %s); "
            "pack from the directory that contains index.html" % ", ".join(hint),
        )
    return members, prefix


def extract_archive(tf, members, prefix, dest):
    for member, name in members:
        rel = name[len(prefix):] if prefix else name
        if not rel:
            continue
        path = os.path.join(dest, rel)
        if member.isdir():
            os.makedirs(path, mode=0o755, exist_ok=True)
            continue
        parent = os.path.dirname(path)
        if parent:
            os.makedirs(parent, mode=0o755, exist_ok=True)
        src = tf.extractfile(member)
        if src is None:
            raise Fail(400, "cannot read %r from the archive" % name)
        with src, open(path, "wb") as out:
            shutil.copyfileobj(src, out, 1024 * 1024)
        os.chmod(path, 0o644)


def safe_label(raw):
    label = "".join(c for c in (raw or "").lower() if c.isalnum() or c in "-_")
    return label[:20]


def publish_stream(read_chunk, label, origin):
    stamp = time.strftime("%Y%m%dT%H%M%SZ", time.gmtime())
    name = "%s-%s" % (stamp, uuid.uuid4().hex[:4])
    if label:
        name = "%s-%s-%s" % (stamp, label, uuid.uuid4().hex[:4])

    incoming = os.path.join(RELEASES, ".incoming-%s" % uuid.uuid4().hex[:8])
    staging = os.path.join(RELEASES, ".staging-%s" % uuid.uuid4().hex[:8])
    written = 0
    try:
        with open(incoming, "wb") as fh:
            while True:
                chunk = read_chunk()
                if not chunk:
                    break
                written += len(chunk)
                if written > MAX_UPLOAD:
                    raise Fail(413, "upload exceeds %d MB" % (MAX_UPLOAD // 1024 // 1024))
                fh.write(chunk)
        if written == 0:
            raise Fail(400, "empty request body")

        try:
            tf = tarfile.open(incoming, mode="r:*")
        except (tarfile.TarError, OSError) as exc:
            raise Fail(400, "body is not a readable tar archive: %s" % exc) from exc

        with tf:
            members, prefix = plan_archive(tf)
            os.makedirs(staging, mode=0o755, exist_ok=True)
            extract_archive(tf, members, prefix, staging)

        files = 0
        unpacked = 0
        for root, _dirs, fnames in os.walk(staging):
            for fname in fnames:
                files += 1
                unpacked += os.path.getsize(os.path.join(root, fname))

        os.rename(staging, os.path.join(RELEASES, name))
        switch_current(name)
        save_meta(name, files=files, bytes=unpacked, upload_bytes=written, label=label)
        prune_releases()
        log("published %s (%d files, %d bytes, stripped=%r)" % (name, files, unpacked, prefix))
        return {
            "ok": True,
            "release": name,
            "files": files,
            "bytes": unpacked,
            "uploadBytes": written,
            "strippedTopDir": prefix or None,
            "url": origin + "/",
        }
    finally:
        for path in (incoming, staging):
            if os.path.exists(path):
                shutil.rmtree(path, ignore_errors=True) if os.path.isdir(path) else os.unlink(path)


class Handler(BaseHTTPRequestHandler):
    server_version = "rhcg-site/1"
    protocol_version = "HTTP/1.1"

    # -- helpers ---------------------------------------------------------
    def log_message(self, fmt, *args):
        log("%s %s" % (self.address_string(), fmt % args))

    def host(self):
        """Host[:port] of this request; no address is ever baked into the build."""
        host = (self.headers.get("Host") or "").strip()
        return host if HOST_RE.match(host) else "localhost"

    def origin(self):
        proto = (self.headers.get("X-Forwarded-Proto") or "https").split(",")[0].strip().lower()
        if proto not in ("http", "https"):
            proto = "https"
        return "%s://%s" % (proto, self.host())

    def reply(self, code, payload, content_type="application/json; charset=utf-8", extra_headers=()):
        if isinstance(payload, (dict, list)):
            body = json.dumps(payload, ensure_ascii=False, indent=2).encode()
        else:
            body = payload.encode() if isinstance(payload, str) else payload
        self.send_response(code)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        for key, value in extra_headers:
            self.send_header(key, value)
        self.end_headers()
        if self.command != "HEAD":
            self.wfile.write(body)

    def require_auth(self):
        header = self.headers.get("Authorization", "")
        supplied = ""
        if header.lower().startswith("bearer "):
            supplied = header[7:].strip()
        supplied = supplied or self.headers.get("X-Auth-Token", "").strip()
        if not supplied or not hmac.compare_digest(supplied, self.server.token):
            raise Fail(401, "missing or wrong token (Authorization: Bearer <token>)")

    def query(self):
        return parse_qs(urlparse(self.path).query, keep_blank_values=True)

    def body_reader(self):
        length = self.headers.get("Content-Length")
        if length is None:
            raise Fail(411, "Content-Length is required; send a file, e.g. curl --data-binary @site.tar.gz")
        try:
            remaining = int(length)
        except ValueError:
            raise Fail(400, "invalid Content-Length") from None
        if remaining < 0:
            raise Fail(400, "invalid Content-Length")

        def read_chunk():
            nonlocal remaining
            if remaining <= 0:
                return b""
            chunk = self.rfile.read(min(remaining, 1024 * 1024))
            if not chunk:
                remaining = 0
                return b""
            remaining -= len(chunk)
            return chunk

        return read_chunk

    def read_json_body(self):
        length = int(self.headers.get("Content-Length") or 0)
        if length <= 0 or length > 64 * 1024:
            return {}
        try:
            return json.loads(self.rfile.read(length) or b"{}")
        except ValueError:
            return {}

    def dispatch(self):
        url = urlparse(self.path)
        route = url.path.rstrip("/") or "/"
        query = parse_qs(url.query, keep_blank_values=True)

        if route in ("/docs", "/docs.md", "/llms.txt") and self.command in ("GET", "HEAD"):
            # @DOMAIN@ 在请求时用客户端实际访问的 Host 填，仓库里不存任何地址
            self.reply(200, self.server.docs.replace("@DOMAIN@", self.host()), "text/markdown; charset=utf-8")
            return
        if route in ("/healthz", "/health") and self.command in ("GET", "HEAD"):
            self.reply(200, {"ok": True, "current": current_release(), "releases": len(list_releases())})
            return

        self.require_auth()

        if route == "/releases" and self.command in ("GET", "HEAD"):
            self.reply(200, {"ok": True, "current": current_release(), "releases": list_releases()})
            return

        if route == "/publish" and self.command in ("POST", "PUT"):
            label = safe_label((query.get("name") or [""])[0])
            with PUBLISH_LOCK:
                result = publish_stream(self.body_reader(), label, self.origin())
            self.reply(200, result)
            return

        if route == "/rollback" and self.command == "POST":
            target = (query.get("release") or [""])[0] or str(self.read_json_body().get("release") or "")
            target = target.strip()
            if not target:
                raise Fail(400, 'body must contain {"release": "<name>"}')
            with PUBLISH_LOCK:
                switch_current(target)
            log("rollback to %s" % target)
            self.reply(200, {"ok": True, "current": current_release(), "url": self.origin() + "/"})
            return

        if route == "/file" and self.command in ("POST", "PUT"):
            rel = (query.get("path") or [""])[0]
            rel = normalize_member_name(rel or "")
            if not rel:
                raise Fail(400, "path query parameter is required, e.g. ?path=assets/style.css")
            release = current_release()
            if not release:
                raise Fail(409, "no release yet, publish a full site first")
            target = os.path.join(RELEASES, release, rel)
            os.makedirs(os.path.dirname(target) or ".", mode=0o755, exist_ok=True)
            read_chunk = self.body_reader()
            written = 0
            tmp = target + ".tmp-%s" % uuid.uuid4().hex[:8]
            try:
                with open(tmp, "wb") as fh:
                    while True:
                        chunk = read_chunk()
                        if not chunk:
                            break
                        written += len(chunk)
                        if written > MAX_UPLOAD:
                            raise Fail(413, "upload exceeds %d MB" % (MAX_UPLOAD // 1024 // 1024))
                        fh.write(chunk)
                os.chmod(tmp, 0o644)
                os.replace(tmp, target)
            finally:
                if os.path.exists(tmp):
                    os.unlink(tmp)
            log("patched %s/%s (%d bytes)" % (release, rel, written))
            self.reply(200, {"ok": True, "release": release, "path": rel, "bytes": written})
            return

        raise Fail(404, "unknown endpoint; see GET /docs")

    def do_GET(self):
        self.run()

    def do_HEAD(self):
        self.run()

    def do_POST(self):
        self.run()

    def do_PUT(self):
        self.run()

    def run(self):
        try:
            self.dispatch()
        except Fail as exc:
            payload = {"ok": False, "error": exc.message}
            payload.update(exc.extra)
            # A rejected upload usually leaves an unread body behind; keeping the
            # connection alive would desynchronise the next request on it.
            self.close_connection = True
            self.reply(exc.code, payload, extra_headers=[("Connection", "close")])
        except BrokenPipeError:
            pass
        except Exception as exc:  # noqa: BLE001 - never leak a traceback to the client
            log("internal error: %r" % exc)
            try:
                self.reply(500, {"ok": False, "error": "internal error: %s" % exc})
            except OSError:
                pass


class Server(ThreadingHTTPServer):
    daemon_threads = True
    allow_reuse_address = True

    def __init__(self, addr, handler, token, docs):
        super().__init__(addr, handler)
        self.token = token
        self.docs = docs


def seed_placeholder():
    """Make the hostname render something sane before the first upload."""
    if current_release():
        return
    name = time.strftime("%Y%m%dT%H%M%SZ", time.gmtime()) + "-placeholder"
    path = os.path.join(RELEASES, name)
    os.makedirs(path, mode=0o755, exist_ok=True)
    with open(os.path.join(path, "index.html"), "w", encoding="utf-8") as fh:
        fh.write(PLACEHOLDER)
    os.chmod(os.path.join(path, "index.html"), 0o644)
    switch_current(name)
    log("seeded placeholder release %s" % name)


def main():
    for path, mode in ((SITE_ROOT, 0o755), (RELEASES, 0o755), (STATE, 0o750)):
        os.makedirs(path, mode=mode, exist_ok=True)
    token = load_or_create_token()
    seed_placeholder()
    docs = "# static site publisher\n\nGET /docs is unavailable: no documentation file was installed.\n"
    if DOCS_FILE:
        with open(DOCS_FILE, "r", encoding="utf-8") as fh:
            docs = fh.read()
    server = Server((BIND, PORT), Handler, token, docs)
    log("listening on %s:%d, site root %s, current=%s" % (BIND, PORT, SITE_ROOT, current_release()))
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    main()
