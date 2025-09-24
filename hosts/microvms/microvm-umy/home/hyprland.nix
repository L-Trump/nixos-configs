# Device specific home settings
{ lib, ... }:
{
  services.hypridle.enable = lib.mkForce false;
}
