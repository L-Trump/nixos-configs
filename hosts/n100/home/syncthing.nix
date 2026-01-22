_: {
  services.syncthing = {
    enable = false;
    extraOptions = [
      "--gui-address=0.0.0.0:8384"
    ];
  };
}
