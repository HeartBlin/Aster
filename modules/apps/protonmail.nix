{ config, lib, pkgs, ... }:

{
  options.Aster.apps.protonmail.enable =
    lib.mkEnableOption "It's a PWA for ProtonMail";

  config = lib.mkIf config.Aster.apps.protonmail.enable {
    hjem.users.${config.Aster.user}.files.".local/share/applications/proton-mail.desktop".text =
      let
        browser = "${pkgs.chromium}/bin/chromium";
        protonUrl = "https://mail.proton.me";
        protonIcon = pkgs.fetchurl {
          url =
            "https://upload.wikimedia.org/wikipedia/commons/0/0c/ProtonMail_icon.svg";
          sha256 = "sha256-rXvj3BRtQsOZfG+milKqS4IotRKEaTklQIwHP7HJqwM=";
        };
      in ''
        [Desktop Entry]
        Version=1.0
        Name=Proton Mail
        GenericName=Email Client
        Comment=Secure Email PWA
        Exec=${browser} --app=${protonUrl} %U
        Icon=${protonIcon}
        Terminal=false
        Type=Application
        Categories=Network;Email;
        StartupWMClass=mail.proton.me
        MimeType=x-scheme-handler/mailto;
      '';
  };
}
