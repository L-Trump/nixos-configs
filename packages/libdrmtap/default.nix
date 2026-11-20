{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libdrm,
  libglvnd,
  libva,
}:

# libdrmtap: DRM/KMS scanout capture (below the compositor, no portal consent).
#
# Pinned to the exact commit rustdesk's build.py pins for the `drm` backend
# (LIBDRMTAP_SHA_PINNED in build.py == libdrmtap v0.5.12). Its ABI is
# versioned and rustdesk only dlopen()s it, so this stays a plain library.
#
# helper=disabled: the privileged `drmtap-helper` (fork/exec + setcap
# CAP_SYS_ADMIN) is dropped from the build. rustdesk only uses that fork path
# when it is unprivileged AND CAP_SYS_ADMIN is unavailable; the unattended
# deployment runs `rustdesk --service` as root, which reads the scanout
# directly. Unprivileged runs then get -EACCES and fall back to PipeWire, which
# is the honest behaviour. Nix cannot grant file capabilities in the store
# anyway, so shipping the helper here would produce a binary that cannot work.
stdenv.mkDerivation (finalAttrs: {
  pname = "libdrmtap";
  version = "0.5.12";

  src = fetchFromGitHub {
    owner = "rustdesk-org";
    repo = "libdrmtap";
    rev = "5936a7a88b94aa43516a3dd0eb509d2383f31e2d";
    hash = "sha256-k/1fW97XhtK9LGJMDpyTuJ5dENIN2Z2gLNjawnwsq74=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libdrm
    libglvnd # egl + glesv2: the GPU detiling path
    libva # optional: GPU-accelerated backends
  ];

  mesonFlags = [
    "-Dhelper=disabled"
    "-Degl=enabled"
    # upstream defaults to warning_level=3 + werror=true; newer compilers add
    # warnings we do not care about
    "-Dwerror=false"
    "-Db_ndebug=true"
  ];

  # the test suite wants a real DRM node and root
  doCheck = false;

  # libEGL/libGLESv2 只用 dlopen 加载（不在 DT_NEEDED 里），fixupPhase 的
  # "shrinking RPATHs" 会把 libglvnd 从 RUNPATH 里剪掉，于是运行期
  # dlopen("libEGL.so.1") 失败 → amdgpu 的 tiled/压缩 scanout 无法 detile
  # → drmtap_grab_mapped 返回 -ENOTSUP。在 fixup 之后再补回去。
  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath [ libglvnd ]} \
      $out/lib/libdrmtap.so.0.5.12
  '';

  meta = {
    description = "DRM/KMS screen capture library (below the compositor, no portal prompts)";
    homepage = "https://github.com/rustdesk-org/libdrmtap";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "libdrmtap.so.0";
  };
})
