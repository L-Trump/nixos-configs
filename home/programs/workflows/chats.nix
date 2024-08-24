{ pkgs, ... }:

{
  home.packages = with pkgs; [
    qq
    wechat-uos-without-sandbox
    nur.repos.linyinfeng.wemeet
  ];
}
