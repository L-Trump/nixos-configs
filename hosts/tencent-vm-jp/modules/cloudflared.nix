{
  inputs,
  pkgs,
  config,
  ...
}: let
  inherit (inputs) mysecrets;
in {
  age.secrets.cf-etltnet-json = {
    file = "${mysecrets}/cloudflared/et-ltnet.json.age";
  };
  environment.systemPackages = with pkgs; [cloudflared];
  services.cloudflared = {
    enable = true;
    user = "root";
    group = "root";
    tunnels.et-ltnet = {
      credentialsFile = "${config.age.secrets.cf-etltnet-json.path}";
      default = "http_status:404";
    };
  };
}
