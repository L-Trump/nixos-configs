# The implementation lives in the private nixos-secrets input
{ inputs, ... }:
{
  imports = [ "${inputs.mysecrets}/rhcg-site" ];
}
