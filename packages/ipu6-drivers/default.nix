{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  ivsc-driver,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  pname = "ipu6-drivers";
  version = "unstable-2024-11-19";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu6-drivers";
    rev = "13c466ebdaaa0578e82bf3039b63eb0b3f472b72";
    hash = "sha256-yBqcgqAEw6K2uG6zzerNaUePui1Ds+8+LcBG2bDfS/k=";
  };

  patches = [
    "${src}/patches/0001-v6.10-IPU6-headers-used-by-PSYS.patch"

    # Fix compilation with kernels >= 6.13
    # https://github.com/intel/ipu6-drivers/pull/321
    (fetchpatch {
      url = "https://github.com/intel/ipu6-drivers/pull/321/commits/414f2d94b5a10e142c22c87e03168957791f5661.patch";
      hash = "sha256-fuEQO83qnXTwZlQXGOjSaJeexjlpqKXd+YLLbfq4xzk=";
    })
    (fetchpatch {
      url = "https://github.com/intel/ipu6-drivers/pull/321/commits/8ac01026f4efbe5697a931af6c3499bd7315bdb6.patch";
      hash = "sha256-hU8R5WAe0lgFz6cR1PAi83+KJYWolohJj9E9jX2zyno=";
    })
  ];

  postPatch = ''
    cp --no-preserve=mode --recursive --verbose \
      ${ivsc-driver.src}/backport-include \
      ${ivsc-driver.src}/drivers \
      ${ivsc-driver.src}/include \
      .
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  enableParallelBuilding = true;

  preInstall = ''
    sed -i -e "s,INSTALL_MOD_DIR=,INSTALL_MOD_PATH=$out INSTALL_MOD_DIR=," Makefile
  '';

  installTargets = [
    "modules_install"
  ];

  meta = {
    homepage = "https://github.com/intel/ipu6-drivers";
    description = "IPU6 kernel driver";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    # requires 6.10
    broken = kernel.kernelOlder "6.10";
  };
}
