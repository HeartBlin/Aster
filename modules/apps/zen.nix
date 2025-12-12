# Oh god this wall hell to figure out
# Basically does what 0xc000022070 home-manager module does
# but with hjem
# I'll actually comment what this does

{ config, inputs, lib, pkgs, ... }:

let
  cfg = config.Aster.apps.zen;

  # Forces extensions to be provisioned, and build the URL
  mkExtensions = builtins.mapAttrs (_: pluginId: {
    install_url =
      "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
    installation_mode = "force_installed";
  });

  # Generated the proper user.js content from our nix thingy
  mkUserJs = prefs:
    lib.concatStringsSep "\n" (lib.mapAttrsToList
      (name: value: ''user_pref("${name}", ${builtins.toJSON value});'') prefs);

  # Zen's config, which are to be fed to mkUserJS -> wrapper
  zenPolicies = {
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    DisableAppUpdate = true;
    DisableFeedbackCommands = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    DontCheckDefaultBrowser = true;
    NoDefaultBookmarks = true;
    OfferToSaveLogins = false;

    ExtensionSettings = mkExtensions {
      "uBlock0@raymondhill.net" = "ublock-origin";
      "sponsorBlocker@ajay.app" = "sponsorblock";
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
      "vpn@proton.ch" = "proton-vpn-firefox-extension";
    };

    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };
  };

  # Zen's preferences, easier to feed to the wrapper
  zenPreferences = {
    "browser.tabs.warnOnClose" = false;
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "browser.ping-centre.telemetry" = false;
    "extensions.pocket.enabled" = false;
    "extensions.screenshots.disabled" = true;
    "dom.security.https_only_mode" = true;
    "dom.security.https_only_mode_ever_enabled" = true;
    "privacy.donottrackheader.enabled" = true;
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.socialtracking.enabled" = true;
    "privacy.partition.network_state.ocsp_cache" = true;

    # Telemetry Disabling, not all encompassing me thinks
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.hybridContent.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.reportingpolicy.firstRun" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
  };

  # Target the unwrapped package from the zen-browser flake
  unwrapped =
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight-unwrapped;

  # Feed it the policies
  unwrappedWithPolicies = unwrapped.override { policies = zenPolicies; };

  # Wrap the browser, given it's unwrapped. Feed it prefs too
  zenWrapped = pkgs.wrapFirefox (unwrappedWithPolicies // {
    inherit (pkgs) gtk3; # While testing, this needed to be here
    applicationName = "Zen Browser";
  }) {
    pname = "zen-browser";
    libName = "zen";
    extraPrefs = mkUserJs zenPreferences;
  };

in {
  options.Aster.apps.zen.enable = lib.mkEnableOption "Zen Browser (Twilight)";

  config = lib.mkIf cfg.enable {
    users.users.${config.Aster.user}.packages = [ zenWrapped ];
  };
}
