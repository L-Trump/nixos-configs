{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  steam-offload = lib.hiPrio (
    pkgs.runCommand "steam-override" {nativeBuildInputs = [pkgs.makeWrapper];} ''
      mkdir -p $out/bin
      makeWrapper ${config.programs.steam.package}/bin/steam $out/bin/steam \
        --set __NV_PRIME_RENDER_OFFLOAD 1 \
        --set __NV_PRIME_RENDER_OFFLOAD_PROVIDER NVIDIA-G0 \
        --set __GLX_VENDOR_LIBRARY_NAME nvidia \
        --set __VK_LAYER_NV_optimus NVIDIA_only
    ''
  );
  # nvidia-package = config.boot.kernelPackages.nvidiaPackages.production;
  nvidia-package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "575.64.05";
    sha256_64bit = "sha256-hfK1D5EiYcGRegss9+H5dDr/0Aj9wPIJ9NVWP3dNUC0=";
    sha256_aarch64 = "sha256-GRE9VEEosbY7TL4HPFoyo0Ac5jgBHsZg9sBKJ4BLhsA=";
    openSha256 = "sha256-mcbMVEyRxNyRrohgwWNylu45vIqF+flKHnmt47R//KU=";
    settingsSha256 = "sha256-o2zUnYFUQjHOcCrB0w/4L6xI1hVUXLAWgG2Y26BowBE=";
    persistencedSha256 = "sha256-2g5z7Pu8u2EiAh5givP5Q1Y4zk4Cbb06W37rf768NFU=";
  };
in {
  # ===============================================================================================
  # for Nvidia GPU
  # ===============================================================================================

  # https://wiki.hyprland.org/Nvidia/
  environment.systemPackages =
    (lib.optionals config.programs.steam.enable [steam-offload])
    ++ [
      pkgs.nvtopPackages.full
    ];
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    # Since NVIDIA does not load kernel mode setting by default,
    # enabling it is required to make Wayland compositors function properly.
    "nvidia-drm.fbdev=1"
  ];
  services.xserver.videoDrivers = ["nvidia"]; # will install nvidia-vaapi-driver by default
  hardware.nvidia = {
    open = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
    package = pkgs.nvidia-patch.patch-nvenc (pkgs.nvidia-patch.patch-fbc nvidia-package);
    # package = nvidia-package;

    nvidiaSettings = true;
    # required by most wayland compositors!
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    # prime.sync.enable = true;
    prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };

  hardware.nvidia-container-toolkit.enable = true;
  hardware.graphics = {
    enable = true;
    # needed by nvidia-docker
    enable32Bit = true;
    extraPackages = with pkgs; [vaapiVdpau amdvlk ocl-icd];
  };

  nixpkgs.config.cudaSupport = true;

  nixpkgs.overlays = [
    (_: super: {
      blender = super.blender.override {
        # https://nixos.org/manual/nixpkgs/unstable/#opt-cudaSupport
        cudaSupport = true;
        waylandSupport = true;
      };

      # ffmpeg-full = super.ffmpeg-full.override {
      #   withNvcodec = true;
      # };
    })
    inputs.nvidia-patch.overlays.default
  ];
}
