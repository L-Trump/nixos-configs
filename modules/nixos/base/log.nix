_: {
  services.journald = {
    extraConfig = ''
      SystemMaxUse=300M
    '';
  };
}
