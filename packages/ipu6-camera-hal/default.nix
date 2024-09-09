{ lib
, stdenv
, fetchFromGitHub

  # build
, cmake
, pkg-config

  # runtime
, expat
, ipu6-camera-bins
, libtool
, gst_all_1

  # Pick one of
  # - ipu6 (Tiger Lake)
  # - ipu6ep (Alder Lake)
  # - ipu6epmtl (Meteor Lake)
, ipuVersion ? "ipu6"
}:
let
  ipuTarget = {
    "ipu6" = "ipu_tgl";
    "ipu6ep" = "ipu_adl";
    "ipu6epmtl" = "ipu_mtl";
  }.${ipuVersion};
in
stdenv.mkDerivation {
  pname = "${ipuVersion}-camera-hal";
  version = "0-unstable-2024-07-19";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu6-camera-hal";
    rev = "8863bda8b15bef415f112700d0fb04e00a48dbee";
    hash = "sha256-hIdo2b8UXXfnWIGMc4MtSb9puhRdnmk+hHs3Ah9UJs8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  PKG_CONFIG_PATH = "${lib.makeLibraryPath [ ipu6-camera-bins ]}/${ipuTarget}/pkgconfig";

  cmakeFlags = [
    "-DIPU_VER=${ipuVersion}"
    # missing libiacss
    "-DUSE_PG_LITE_PIPE=ON"
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error"
  ];

  enableParallelBuilding = true;

  buildInputs = [
    expat
    ipu6-camera-bins
    libtool
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace ' usr/' " "
    substituteInPlace src/platformdata/PlatformData.h \
      --replace '/etc/camera/' "${placeholder "out"}/etc/camera/"
  '';

  postFixup = ''
    for lib in $out/lib/*.so; do
      patchelf --add-rpath "${lib.makeLibraryPath [ ipu6-camera-bins ]}/${ipuTarget}" $lib
    done
  '';

  passthru = {
    inherit ipuVersion;
  };

  meta = with lib; {
    description = "HAL for processing of images in userspace";
    homepage = "https://github.com/intel/ipu6-camera-hal";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
