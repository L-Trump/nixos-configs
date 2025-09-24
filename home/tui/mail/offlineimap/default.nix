{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg.pythonFile = ''
    #! /usr/bin/env python
    from subprocess import check_output

    def get_pass(account):
        return check_output("passage Email/" + account, shell=True).splitlines()[0]
  '';
  cfg.package = pkgs.offlineimap;
in
{
  home.packages = [ cfg.package ];
  xdg.configFile."offlineimap/get_settings.py".text = cfg.pythonFile;
  xdg.configFile."offlineimap/get_settings.pyc".source = "${
    pkgs.runCommandLocal "get_settings-compile"
      {
        nativeBuildInputs = [ cfg.package ];
        pythonFile = cfg.pythonFile;
        passAsFile = [ "pythonFile" ];
      }
      ''
        mkdir -p $out/bin
        cp $pythonFilePath $out/bin/get_settings.py
        python -m py_compile $out/bin/get_settings.py
      ''
  }/bin/get_settings.pyc";
}
