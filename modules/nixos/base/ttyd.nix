{
  lib,
  myvars,
  ...
}:
{
  services.ttyd = {
    enable = true;
    writeable = true;
    interface = "easytier.ltnet";
  };
}
