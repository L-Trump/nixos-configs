{
  lib,
  ...
}:
{
  "intervalCommand" = {
    "variants" = [
      {
        "id" = "variant_1795622036430";
        "name" = "Mail";
        "command" = "count-unread-mail";
        "icon" = "mail";
        "clickCommand" = "gtk-launch aerc";
        "refreshInterval" = 5;
        "useAccentColor" = false;
      }
    ];
  };
}
