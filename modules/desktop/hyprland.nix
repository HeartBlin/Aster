{ config, inputs, lib, pkgs, self, ... }:

let
  cfg = config.Aster.desktop.hyprland;

  # Helpers
  hypr = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
  uwsm = "uwsm app --";

  # Scripts
  batteryNotify = ''
    hyprctl notify 2 4000 "0xff444444" "fontsize:15 Battery: $(cat /sys/class/power_supply/BAT0/capacity)%"'';
  clockNotify =
    ''hyprctl notify 2 4000 "0xff444444" "fontsize:15 $(date +'%H:%M')"'';

  wallpaperRandomizer = pkgs.writeShellScriptBin "wallpaperRandomizer" ''
    DIR="${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers}"
    CURRENT_FULL=$(awww query | grep -oP "image: \K.*")
    CURRENT_CLEAN=$(basename "$CURRENT_FULL" | sed -E 's/^[a-z0-9]{32}-//')

    # Try to find a new wallpaper that isn't the current one
    TARGET=$(find -L "$DIR" -type f | grep -vE "/([a-z0-9]{32}-)?$CURRENT_CLEAN$" | shuf -n 1)

    # Fallback if filter fails
    [ -z "$TARGET" ] && TARGET=$(find -L "$DIR" -type f | shuf -n 1)

    awww img "$TARGET" --transition-type any --transition-fps 144 --transition-duration 1
  '';

  # Big boy
  hyprGameMode = pkgs.writeShellScriptBin "hyprGameMode" ''
    HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')

    if [ "$HYPRGAMEMODE" = 1 ] ; then
      hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"

      awww pause
      hyprctl notify 1 5000 "rgb(40a02b)" "Gamemode [ON]"
      exit
    fi

    hyprctl reload
    awww pause
    hyprctl notify 1 5000 "rgb(d20f39)" "Gamemode [OFF]"
  '';

  # Avoid typing the same 20 things over and over
  workspaceBinds = builtins.concatLists (builtins.genList (x:
    let
      ws = let n = x + 1; in if n == 10 then 10 else n;
      key = if ws == 10 then "0" else toString ws;
    in [
      "Super, ${key}, workspace, ${toString ws}"
      "Super Shift, ${key}, movetoworkspace, ${toString ws}"
    ]) 10);

in {
  imports = [ inputs.hyprland.nixosModules.default ];
  options.Aster.desktop.hyprland.enable =
    lib.mkEnableOption "Hyprland Compositor";

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = hypr.hyprland;
      portalPackage = hypr.xdg-desktop-portal-hyprland;

      settings = {
        # Environment & Monitors
        monitor = [ "eDP-1, 1920x1080@144, 0x0, 1" ", preferred, auto, 1" ];
        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
          "GDK_BACKEND,wayland,x11,*"
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "SDL_VIDEODRIVER,wayland"
          "ELECTRON_OZONE_PLATFORM_HINT,wayland"
          "OZONE_PLATFORM,wayland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_DESKTOP,Hyprland"
        ];

        # The funny Xwayland
        xwayland.force_zero_scaling = true;

        # Autostarters
        exec-once = [
          "uwsm finalize"
          "vicinae server"
          "swayosd-server"
          "GalaxyBudsClient /StartMinimized"
          "awww-daemon"
          "systemctl --user import-environment $(env | cut -d'=' -f 1)"
          "dbus-update-activation-environment --systemd --all"
          "hyprctl setcursor Bibata-Modern-Ice 24" # Bub fix
        ];

        # Appearance
        general = {
          border_size = 2;
          gaps_in = 10;
          gaps_out = 20;
          resize_on_border = true;
          allow_tearing = true;
          "col.inactive_border" = "0xff444444";
          "col.active_border" =
            "0xffef7e7e 0xffe57474 0xfff4d67a 0xffe5c76b 0xff96d988 0xff8ccf7e 0xff67cbe7 0xff6cbfbf 0xff71baf2 0xffc47fd5 45deg";
        };

        decoration = {
          rounding = 10;
          rounding_power = 3;
          blur = {
            enabled = true;
            brightness = 1.0;
            contrast = 1.0;
            noise = 1.0e-2;
            vibrancy = 0.2;
            vibrancy_darkness = 0.5;
            passes = 4;
            size = 7;
            popups = true;
            popups_ignorealpha = 0.2;
          };
          shadow = {
            enabled = true;
            color = "0x00000055";
            ignore_window = true;
            offset = "0 15";
            range = 100;
            render_power = 2;
            scale = 1.0;
          };
        };

        # Input
        input = {
          kb_layout = "ro";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad = {
            natural_scroll = false;
            clickfinger_behavior = true;
            disable_while_typing = true;
            tap-to-click = true;
          };
        };

        # Keybindings
        bind = [
          # Apps
          "Super, Return, exec, ${uwsm} foot"
          "Super, Space, exec, ${uwsm} vicinae toggle"
          "Super, E, exec, ${uwsm} nautilus"
          "Super, W, exec, ${uwsm} zen-twilight"
          "Super Shift, B, exec, ${uwsm} GalaxyBudsClient app -a"
          "Super, B, exec, ${batteryNotify}"
          "Super, C, exec, ${clockNotify}"
          ", Print, exec, hyprshot -m region"
          "Super, Tab, exec, wallpaperRandomizer"
          "Super, G, exec, hyprGameMode"

          # System
          "Super, Q, killactive"
          "Super Shift, Q, exit"
          "Super Shift Control Tab, Q, exec, systemctl poweroff"
        ] ++ workspaceBinds; # Thought I forgot about this didn't cha?

        # Mouse moment
        bindm =
          [ "Super, mouse:272, movewindow" "Super, mouse:273, resizewindow" ];

        # Getting the media keys to work
        bindel = [
          ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
          ",XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
          ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
          ",XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
          ",XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
          ",XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
          ",XF86AudioPlay, exec, swayosd-client --playerctl play-pause"
        ];

        # Rules
        windowrule = [
          "match:class cs2, immediate yes"
          "match:class steam_app_218620, immediate yes"
        ];

        layerrule = [
          "match:namespace vicinae, blur true"
          "match:namespace vicinae ignorealpha 0"
        ];

        render.direct_scanout = 1;

        # Shut up!
        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };
        misc.disable_autoreload = false; # Pease refresh on build kthxbye
      };

      extraConfig = "";
    };

    # UWSM Configuration, cause I want to use start-hyprland
    programs.uwsm = {
      enable = true;
      waylandCompositors.hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/start-hyprland";
      };
    };

    users.users.${config.Aster.user}.packages = with pkgs; [
      swayosd
      hyprshot
      inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
      wallpaperRandomizer
      hyprGameMode
    ];
  };
}
