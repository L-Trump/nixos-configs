#!/usr/bin/env python3
"""Add 2x nearest-neighbour copies of every image in an Xcursor theme.

Usage: xcursor-upscale.py <theme-cursors-dir>

niri asks for cursors at ``xcursor_size * ceil(output_scale)``.  A theme that
only ships one pixel size (e.g. 32px art) cannot satisfy the doubled request on
fractional-scale outputs, falls back to the smaller image and ends up drawing
a physically smaller cursor.  For every image chunk of nominal size N this
script appends a copy with nominal size 2*N, dimensions doubled, hotspots
doubled and every pixel repeated 2x2 (exact nearest neighbour, so pixel art
stays sharp).
"""

import glob
import os
import struct
import sys

MAGIC = b"Xcur"
IMAGE_TYPE = 0xFFFD0002
HEADER_SIZE = 16


def parse(path):
    try:
        with open(path, "rb") as f:
            data = f.read()
    except OSError as err:
        raise ValueError(f"{path}: cannot read cursor file: {err}") from err
    if data[:4] != MAGIC:
        return None
    hdrsize, version, ntoc = struct.unpack("<III", data[4:16])
    if hdrsize != HEADER_SIZE:
        raise ValueError(f"{path}: unexpected header size {hdrsize}")
    chunks = []
    for i in range(ntoc):
        ctype, subtype, pos = struct.unpack("<III", data[16 + i * 12:28 + i * 12])
        if ctype != IMAGE_TYPE:
            # Comments are irrelevant to rendering; drop them.
            continue
        (header, ctype2, subtype2, cver, width, height,
         xhot, yhot, delay) = struct.unpack("<IIIIIIIII", data[pos:pos + 36])
        npix = width * height
        pixels = data[pos + 36:pos + 36 + npix * 4]
        if len(pixels) != npix * 4:
            raise ValueError(f"{path}: truncated image chunk")
        chunks.append(dict(subtype=subtype, version=cver, width=width,
                           height=height, xhot=xhot, yhot=yhot, delay=delay,
                           pixels=pixels))
    return version, chunks


def upscale(chunk):
    w, h = chunk["width"], chunk["height"]
    px = chunk["pixels"]
    rows = []
    for y in range(h):
        row = px[y * w * 4:(y + 1) * w * 4]
        doubled = b"".join(row[x * 4:x * 4 + 4] * 2 for x in range(w))
        rows.append(doubled)
        rows.append(doubled)
    return dict(subtype=chunk["subtype"] * 2, version=chunk["version"],
                width=w * 2, height=h * 2, xhot=chunk["xhot"] * 2,
                yhot=chunk["yhot"] * 2, delay=chunk["delay"],
                pixels=b"".join(rows))


def build(chunks):
    have = {(c["subtype"], c["width"], c["height"]) for c in chunks}
    added = [u for u in (upscale(c) for c in chunks)
             if (u["subtype"], u["width"], u["height"]) not in have]
    all_chunks = chunks + added
    ntoc = len(all_chunks)
    offset = HEADER_SIZE + ntoc * 12
    toc = b""
    body = b""
    for c in all_chunks:
        toc += struct.pack("<III", IMAGE_TYPE, c["subtype"], offset)
        header = struct.pack("<IIIIIIIII", 36, IMAGE_TYPE, c["subtype"],
                             c["version"], c["width"], c["height"],
                             c["xhot"], c["yhot"], c["delay"])
        body += header + c["pixels"]
        offset += len(header) + len(c["pixels"])
    return MAGIC + struct.pack("<III", HEADER_SIZE, 0x10000, ntoc) + toc + body


def main(argv):
    if len(argv) != 2:
        sys.exit(__doc__)
    root = argv[1]
    done = skipped = 0
    for path in sorted(glob.glob(os.path.join(root, "*"))):
        if not os.path.isfile(path):
            continue
        parsed = parse(path)
        if parsed is None:
            skipped += 1
            continue
        version, chunks = parsed
        data = build(chunks)
        try:
            mode = os.stat(path).st_mode
            with open(path, "wb") as f:
                f.write(data)
            os.chmod(path, mode)
        except OSError as err:
            sys.exit(f"{path}: cannot write cursor file: {err}")
        done += 1
    print(f"upscaled {done} cursor files, skipped {skipped}")


if __name__ == "__main__":
    main(sys.argv)
