{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nvimdots.homeManagerModules.nvimdots
  ];
  programs.neovim = {
    withRuby = true;
    withPython3 = true;

    nvimdots = {
      enable = false;
      mergeLazyLock = true;
      setBuildEnv = true;
      withBuildTools = true;
    };
  };

  programs.neovim.extraPackages = with pkgs; [
    lazygit
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    SYSTEMD_EDITOR = "nvim";
  };
}
