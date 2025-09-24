{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nvimdots.homeManagerModules.nvimdots
  ];
  programs.neovim.nvimdots = {
    enable = true;
    mergeLazyLock = true;
    setBuildEnv = true;
    withBuildTools = true;
  };

  programs.neovim.extraPackages = with pkgs; [
    lazygit
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    SYSTEMD_EDITOR = "nvim";
  };
}
