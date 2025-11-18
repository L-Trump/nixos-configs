{
  pkgs,
  pkgs-stable,
  ...
}:
{
  home.packages = with pkgs; [
    # e-book viewer(.epub/.mobi/...)
    # do not support .pdf
    # foliate
    wpsoffice-cn
    # wpsoffice-365
    nur.repos.rewine.ttf-wps-fonts
    # pkgs-stable.logseq
    # vikunja
    typora
    xournalpp
    # edrawmax-cn
    siyuan
    tesseract # for siyuan OCR, ~1GB space consumption
  ];

  programs.zathura = {
    enable = true;
    extraConfig = ''
      unmap f
      map f toggle_fullscreen
      map [fullscreen] f toggle_fullscreen
      map <Button8> navigate next
      map <Button9> navigate previous
      map [presentation] <Button8> navigate next
      map [presentation] <Button9> navigate previous
    '';
    options = {
      window-height = 3000;
      window-width = 1000;
      statusbar-h-padding = 0;
      statusbar-v-padding = 0;
      page-padding = 10;
      window-title-page = true;
      guioptions = "vc";
      scroll-step = 40;
      selection-clipboard = "clipboard";
      notification-error-fg = "#f28fad";
      notification-warning-bg = "#beade9";
      notification-warning-fg = "#f28fad";
      notification-bg = "#beade9";
      notification-fg = "#f28fad";
      completion-group-bg = "#beade9";
      completion-group-fg = "#abe9b3";
      completion-bg = "#1c1d2d";
      completion-fg = "#c3bac6";
      completion-highlight-bg = "#abe9b3";
      completion-highlight-fg = "#beade9";
      inputbar-bg = "#1c1d2d";
      inputbar-fg = "#c3bac6";
      statusbar-bg = "#beade9";
      statusbar-fg = "#c3bac6";
      highlight-color = "#abe9b3";
      highlight-active-color = "#96cdfb";
      default-bg = "#beade9";
      default-fg = "#c3bac6";
      recolor-lightcolor = "#1c1d2d";
      recolor-darkcolor = "#c3bac6";
      index-bg = "#1c1d2d";
      index-fg = "#c3bac6";
      index-active-bg = "#abe9b3";
      index-active-fg = "#beade9";
    };
  };

  # xdg.desktopEntries.logseq = {
  #   name = "Logseq";
  #   exec = ''env NIXOS_OZONE_WL=1 logseq --enable-wayland-ime %u'';
  #   icon = "logseq";
  #   settings.StartupWMClass = "logseq";
  #   comment = "A privacy-first, open-source platform for knowledge management and collaboration.";
  #   mimeType = ["x-scheme-handler/logseq"];
  #   categories = ["Office" "Utility"];
  # };
}
