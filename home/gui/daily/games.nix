{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.myhome.desktop.daily.game;
in
{
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        # nix-gaming.packages.${pkgs.system}.osu-laser-bin
        gamescope # SteamOS session compositing window manager
        prismlauncher # A free, open source launcher for Minecraft
        winetricks # A script to install DLLs needed to work around problems in Wine
      ];
    })
    {
      home.packages = with pkgs; [ moonlight-qt ];
    }
  ];
}
