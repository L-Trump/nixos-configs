# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ltrump = {
    isNormalUser = true;
    description = "ltrump";
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  nix.settings = {
    substituters = [ 
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];
    builders-use-substitutes = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
  

  # Enable CUPS to print documents.
  services.printing.enable = true;

  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons

      # normal fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      source-code-pro

      # nerdfonts
      (nerdfonts.override {fonts = [ "FiraCode" "JetBrainsMono" ];})
    ];

  # enableDefaultPackages = false;

  # fontconfig.defaultFonts = {
  #   serif = [ "Noto Serif" "Noto Color Emoji" ];
  #   sansSerif = [ "Noto Sans" "Noto Color Emoji" ];
  #   monospace = [ "JetBrainMono Nerd Font" "Noto Color Emoji" ];
  #   emoji = [ "Noto Color Emoji" ];
  # };
  };

  programs.dconf.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      # PasswordAuthentication = false;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    curl
    git
    sysstat
    lm_sensors
    fastfetch
    nnn
    xfce.thunar
    killall
    tmux

    python312
    python312Packages.pip
    clang-tools
    cmake
    gccgo
    go
    nodejs_22

    fuse
    fuse3
  ];

  # Enable sound by pipewire.
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  security.polkit.enable = true;
  security.sudo.extraRules = [
    {
      users = [ "ltrump" ];
      commands = [ 
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

# services.power-profiles-daemon = {
#   enable = true;
# };

  services.dbus.packages = [ pkgs.gcr ];
  services.geoclue2.enable = true;

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  services.fwupd.enable = true;

  programs.npm.enable = true;
  programs.clash-verge = {
    enable = true;
    autoStart = false;
    tunMode = true;
    package = pkgs.clash-verge-rev;
  };

  systemd.services.clash-verge-rev = {
    enable = true;
    description = "Clash Verge Rev Service";
    serviceConfig = {
      ExecStart = "${pkgs.clash-verge-rev}/lib/clash-verge/resources/clash-verge-service";
    };
    wantedBy = [ "multi-user.target" ];
  };

  programs.fish.enable = true;

  environment.shellAliases = {
    l = null;
    ls = null;
    ll = null;
  };
}

