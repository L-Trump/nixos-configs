{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  steam-offload = lib.hiPrio (
    pkgs.runCommand "steam-override" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
      mkdir -p $out/bin
      makeWrapper ${config.programs.steam.package}/bin/steam $out/bin/steam \
        --set __NV_PRIME_RENDER_OFFLOAD 1 \
        --set __NV_PRIME_RENDER_OFFLOAD_PROVIDER NVIDIA-G0 \
        --set __GLX_VENDOR_LIBRARY_NAME nvidia \
        --set __VK_LAYER_NV_optimus NVIDIA_only
    ''
  );
  # nvidia-package = config.boot.kernelPackages.nvidiaPackages.latest;
  nvidia-package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "590.48.01";
    sha256_64bit = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
    sha256_aarch64 = "sha256-FOz7f6pW1NGM2f74kbP6LbNijxKj5ZtZ08bm0aC+/YA=";
    openSha256 = "sha256-hECHfguzwduEfPo5pCDjWE/MjtRDhINVr4b1awFdP44=";
    settingsSha256 = "sha256-NWsqUciPa4f1ZX6f0By3yScz3pqKJV1ei9GvOF8qIEE=";
    persistencedSha256 = "sha256-wsNeuw7IaY6Qc/i/AzT/4N82lPjkwfrhxidKWUtcwW8=";
  };
in
{
  # ===============================================================================================
  # for Nvidia GPU
  # ===============================================================================================

  # https://wiki.hyprland.org/Nvidia/
  environment.systemPackages = (lib.optionals config.programs.steam.enable [ steam-offload ]) ++ [
    pkgs.nvtopPackages.full
  ];
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    # Since NVIDIA does not load kernel mode setting by default,
    # enabling it is required to make Wayland compositors function properly.
    "nvidia-drm.fbdev=1"
  ];
  services.xserver.videoDrivers = [ "nvidia" ]; # will install nvidia-vaapi-driver by default
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
    extraPackages = with pkgs; [
      libva-vdpau-driver
      # amdvlk
      ocl-icd
    ];
  };

  nixpkgs.config.cudaSupport = true;

  nixpkgs.overlays = [
    (_: super: {
      blender = super.blender.override {
        # https://nixos.org/manual/nixpkgs/unstable/#opt-cudaSupport
        cudaSupport = true;
        waylandSupport = true;
      };
      onnxruntime = super.onnxruntime.override {
        cudaSupport = false;
      };

      # ffmpeg-full = super.ffmpeg-full.override {
      #   withNvcodec = true;
      # };
    })
    inputs.nvidia-patch.overlays.default
  ];
}
