{ config, inputs, lib, pkgs, ... }:

let
  ctx = config.aster;
  mkExtensions = builtins.mapAttrs (_: pluginId: {
    install_url =
      "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
    installation_mode = "force_installed";
  });

  myPolicies = {
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

  myPrefs = {
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

  mkUserJs = prefs:
    lib.concatStringsSep "\n" (lib.mapAttrsToList
      (name: value: ''user_pref("${name}", ${builtins.toJSON value});'') prefs);

  unwrapped =
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight-unwrapped;

  unwrappedWithPolicies = unwrapped.override { policies = myPolicies; };

  zen-wrapped = pkgs.wrapFirefox (unwrappedWithPolicies // {
    inherit (pkgs) gtk3;
    applicationName = "Zen Browser";
  }) {
    pname = "zen-browser";
    libName = "zen";
    extraPrefs = mkUserJs myPrefs;
  };
in {
  users.users = lib.genAttrs ctx.users (_: { packages = [ zen-wrapped ]; });
}
