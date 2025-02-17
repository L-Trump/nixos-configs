{
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
    "nvidia_drm.fbdev=1"
  ];
  services.xserver.videoDrivers = ["nvidia"]; # will install nvidia-vaapi-driver by default
  hardware.nvidia = {
    open = false;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
    # package = config.boot.kernelPackages.nvidiaPackages.stable;

    # required by most wayland compositors!
    modesetting.enable = true;
    powerManagement.enable = true;
    # powerManagement.finegrained = true;
    prime.sync.enable = true;
    prime.offload = {
      enable = false;
      # enableOffloadCmd = true;
    };
  };

  hardware.nvidia-container-toolkit.enable = true;
  hardware.graphics = {
    enable = true;
    # needed by nvidia-docker
    enable32Bit = true;
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
  ];
}
