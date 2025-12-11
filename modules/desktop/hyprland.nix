{ config, inputs, pkgs, self, ... }:

let
  inherit (config.aster) user;
  hypr = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
  uwsm = "uwsm app --";
  battery = ''
    hyprctl notify 2 4000 "0xff444444" "fontsize:15 Battery: $(cat /sys/class/power_supply/BAT0/capacity)%"'';
  clock = ''hyprctl notify 2 4000 "0xff444444" "fontsize:15 $(date +'%H:%M')"'';

  wallpaperRandomizer = pkgs.writeShellScriptBin "wallpaperRandomizer" ''
    DIR="${self.packages.${pkgs.stdenv.hostPlatform.system}.wallpapers}"
    CURRENT_FULL=$(awww query | grep -oP "image: \K.*")
    CURRENT_CLEAN=$(basename "$CURRENT_FULL" | sed -E 's/^[a-z0-9]{32}-//')
    TARGET=$(find -L "$DIR" -type f | grep -vE "/([a-z0-9]{32}-)?$CURRENT_CLEAN$" | shuf -n 1)
    [ -z "$TARGET" ] && TARGET=$(find -L "$DIR" -type f | shuf -n 1)

    awww img "$TARGET" --transition-type any --transition-fps 144 --transition-duration 1
  '';

  hyprGameMode = pkgs.writeShellScriptBin "hyprGameMode" ''
    gamemode_on() {
      hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword animation borderangle,0; \
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword decoration:fullscreen_opacity 1;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
      awww pause
      hyprctl notify 1 5000 "rgb(40a02b)" "Gamemode [ON]"
    }

    gamemode_off() {
      hyprctl notify 1 5000 "rgb(d20f39)" "Gamemode [OFF]"
      awww pause
      hyprctl reload
    }

    HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
    if [ "$HYPRGAMEMODE" = 1 ] ; then
      gamemode_on
    else
      gamemode_off
    fi
  '';
in {

  programs = {
    hyprland = {
      enable = true;
      package = hypr.hyprland;
      portalPackage = hypr.xdg-desktop-portal-hyprland;
      settings = {
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

        monitor = [
          "eDP-1, 1920x1080@144, 0x0, 1"
          ", preferred, auto, 1" # For any undeclared monitors
        ];

        xwayland.force_zero_scaling = true;
        exec-once = [
          # Finish setup
          "uwsm finalize"

          "vicinae server"
          "swayosd-server"
          "GalaxyBudsClient /StartMinimized" # Powershell lmao

          # Wallpaper
          "awww-daemon"

          # Fixes
          "systemctl --user import-environment $(env | cut -d'=' -f 1)"
          "dbus-update-activation-environment --systemd --all"
          "hyprctl setcursor Bibata-Modern-Ice 24"
        ];

        general = {
          border_size = 2;
          gaps_in = 10;
          gaps_out = 20;
          resize_on_border = true;
          allow_tearing = true; # On that X11 grind
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
            noise = 1.0e-2; # Bruh why does nixfmt not like 0.01 wtf?

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

        bind = [
          # Applications
          "Super, Return, exec, ${uwsm} foot"
          "Super, Space, exec, ${uwsm} vicinae toggle"
          "Super, E, exec, ${uwsm} nautilus"
          "Super, W, exec, ${uwsm} zen-twilight"
          "Super Shift, B, exec, ${uwsm} GalaxyBudsClient app -a"
          "Super, B, exec, ${battery}"
          "Super, C, exec, ${clock}"
          ", Print, exec, hyprshot -m region"
          "Super, Tab, exec, wallpaperRandomizer"
          "Super, G, exec, hyprGameMode" # Oh boy it's gaming™ time™

          # Close windows/Hyprland/poweroff
          "Super, Q, killactive"
          "Super Shift, Q, exit"
          "Super Shift Control Tab, Q, exec, systemctl poweroff"

          # Switch workspaces
          "Super, 1, workspace, 1"
          "Super, 2, workspace, 2"
          "Super, 3, workspace, 3"
          "Super, 4, workspace, 4"
          "Super, 5, workspace, 5"
          "Super, 6, workspace, 6"
          "Super, 7, workspace, 7"
          "Super, 8, workspace, 8"
          "Super, 9, workspace, 9"
          "Super, 0, workspace, 10"

          # Move active window to workspace
          "Super Shift, 1, movetoworkspace, 1"
          "Super Shift, 2, movetoworkspace, 2"
          "Super Shift, 3, movetoworkspace, 3"
          "Super Shift, 4, movetoworkspace, 4"
          "Super Shift, 5, movetoworkspace, 5"
          "Super Shift, 6, movetoworkspace, 6"
          "Super Shift, 7, movetoworkspace, 7"
          "Super Shift, 8, movetoworkspace, 8"
          "Super Shift, 9, movetoworkspace, 9"
          "Super Shift, 0, movetoworkspace, 10"
        ];

        bindm =
          [ "Super, mouse:272, movewindow" "Super, mouse:273, resizewindow" ];

        bindel = [
          ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
          ",XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
          ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
          ",XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
          ",XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
          ",XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
          ",XF86AudioPlay, exec, swayosd-client --playerctl play-pause"
        ];

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

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

        misc.disable_autoreload = true;
        render.direct_scanout = 1;

        windowrule = [
          "match:class cs2, immediate yes" # CS2
          "match:class steam_app_218620, immediate yes" # Payday 2
        ];

        layerrule = [
          "match:namespace vicinae, blur true"
          "match:namespace vicinae ignorealpha 0"
        ];
      };

      extraConfig = "\n";
    };

    uwsm = {
      enable = true;
      waylandCompositors.hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/start-hyprland";
      };
    };
  };

  users.users.${user}.packages = with pkgs; [
    swayosd
    hyprshot
    inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    wallpaperRandomizer
    hyprGameMode
  ];
}
