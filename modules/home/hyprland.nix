{ config, lib, ... }:
{
  options.my.hyprland.monitor = lib.mkOption {
    type = lib.types.submodule {
      options = {
        output = lib.mkOption {
          type = lib.types.str;
          default = "";
        };

        mode = lib.mkOption {
          type = lib.types.str;
          default = "preferred";
        };

        position = lib.mkOption {
          type = lib.types.str;
          default = "auto";
        };

        scale = lib.mkOption {
          type = lib.types.float;
          default = 1.0;
        };
      };
    };

    default = { };
    description = "Hyprland monitor configuration";
  };

  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      # plugins = [
      # hyprplugins.hyprtrails
      # ];
      # extraConfig = " ";

      settings = {
        env = [
          "NIXOS_OZONE_WL, 1"
          "XDG_CURRENT_DESKTOP, Hyprland"
          "XDG_SESSION_TYPE, wayland"
          "XDG_SESSION_DESKTOP, Hyprland"
          "GDK_BACKEND, wayland, x11"
          "CLUTTER_BACKEND, wayland"
          "QT_QPA_PLATFORM=wayland;xcb"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
          "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
          "SDL_VIDEODRIVER, x11"
          "MOZ_ENABLE_WAYLAND, 1"
          "ELECTRON_OZONE_PLATFORM_HINT,wayland" # This is to make electron apps start in wayland
          "GDK_SCALE,1"
          "QT_SCALE_FACTOR,1"
          "TERMINAL,kitty"
          "XDG_TERMINAL_EMULATOR,kitty"
          # "XCURSOR_SIZE,24" # Commenting out for now to see if it affects
        ];

        exec-once = [
          "swww-daemon --format xrgb"
          "swww img $wallpaper --transition-step 255"
          "wl-paste --type text --watch cliphist store" # Saves text
          "wl-paste --type image --watch cliphist store" # Saves images
          "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "systemctl --user start hyprpolkitagent"
          "waybar"
          "dunst"
          "nm-applet --indicator"
        ];

        animations = {
          # enabled = true;
          # bezier = [
          #   "wind, -1.05, 0.9, 0.1, 1.05"
          #   "winIn, -1.1, 1.1, 0.1, 1.1"
          #   "winOut, -1.3, -0.3, 0, 1"
          #   "liner, 0, 1, 1, 1"
          # ];
          # animation = [
          #   "windows, 0, 6, wind, slide"
          #   "windowsIn, 0, 6, winIn, slide"
          #   "windowsOut, 0, 5, winOut, slide"
          #   "windowsMove, 0, 5, wind, slide"
          #   "border, 0, 1, liner"
          #   "fade, 0, 10, default"
          #   "workspaces, 0, 5, wind"
          # ];
        };

        cursor = {
          no_hardware_cursors = 1;
          warp_on_change_workspace = 2;
          no_warps = true;
        };

        decoration = {
          # rounding = 10;
          # blur = {
          #   enabled = true;
          #   size = 4;
          #   passes = 4;
          #   ignore_opacity = true;
          #   new_optimizations = true;
          # };
          # shadow = {
          #   enabled = true;
          #   range = 4;
          #   render_power = 3;
          #   color = "rgba(1a1a1aee)";
          # };
          # active_opacity = 0.95;
          # inactive_opacity = 0.7;
        };

        dwindle = {
          pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true;
          smart_resizing = true;
          use_active_for_splits = true;
          smart_split = false;
          default_split_ratio = 1.0;
          split_bias = 0;
          precise_mouse_move = false;
          special_scale_factor = 0.8;
        };

        general = {
          layout = "dwindle";
          gaps_in = 3;
          gaps_out = 9;
          # border_size = 2;
          # resize_on_border = true;
          # "col.active_border" = "rgba(fb4934ee) rgba(fabd2fee) rgba(83a598ee) 45deg";
          # "col.inactive_border" = "rgba(595959aa) 45deg";
        };

        gestures = {
          gesture = [ "3, horizontal, workspace" ];
          workspace_swipe_distance = 500;
          workspace_swipe_invert = true;
          workspace_swipe_min_speed_to_force = 30;
          workspace_swipe_cancel_ratio = 0.5;
          workspace_swipe_create_new = true;
          workspace_swipe_forever = true;
        };

        input = {
          kb_layout = "us";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad = {
            natural_scroll = true;
            disable_while_typing = false;
          };
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          enable_swallow = false;
        };

        monitorv2 = config.my.hyprland.monitor;

        # Ensure Xwayland windows render at integer scale; compositor scales them
        xwayland = {
          force_zero_scaling = true;
        };

        extraConfig = ''
          windowrule = float on, match:class file_progress
          windowrule = float on, match:class confirm
          windowrule = float on, match:class dialog
          windowrule = float on, match:class download
          windowrule = float on, match:class notification
          windowrule = float on, match:class error
          windowrule = float on, match:class splash
          windowrule = float on, match:class confirmreset
          windowrule = float on, match:title Open File
          windowrule = float on, match:title Save File
          windowrule = float on, match:title Open Folder
          windowrule = float on, match:title branchdialog
          windowrule = float on, match:class Lxappearance
          windowrule = float on, match:title wofi
          windowrule = float on, match:class viewnior
          # windowrule = float,feh
          windowrule = float on, match:class pavucontrol-qt
          windowrule = float on, match:class pavucontrol
          # windowrule = float, file-roller
          windowrule = fullscreen on, float on, match:title wlogout
          windowrule = fullscreen on, match:title Waydroid
          windowrule = idle_inhibit focus, match:class mpv
          windowrule = idle_inhibit fullscreen, match:class firefox
          windowrule = float on, match:title ^(Media viewer)$
          windowrule = float on, size 800 600, move ((monitor_w*0.39)) (420), match:title ^(Volume Control)$
          windowrule = float on, match:title ^(Picture-in-Picture)$
          windowrule = float on, match:title ^(Authentication Required — PolicyKit1 KDE Agent)$

          windowrule = workspace 1, match:class ^(kitty)$
          windowrule = workspace 2, match:class ^(org.kde.dolphin)$
          windowrule = workspace 2, match:class ^(thunar)$
          windowrule = workspace 2, match:title lf
          windowrule = workspace 3, match:class ^(google-chrome)$
          windowrule = workspace 3, match:class ^(firefox)$
          windowrule = workspace 3, match:class ^(discord)$
          windowrule = workspace 4, match:class ^(code)$
          windowrule = workspace 4, match:class ^(dev.zed.Zed)$
          windowrule = workspace 4, match:class ^(jetbrains-studio)$
          windowrule = workspace 5, match:class ^(steam)$
          windowrule = workspace 5, match:class ^(steam_app\d+)$
          windowrule = workspace 5, match:title ^(Emulator)$
          windowrule = workspace 6, match:class ^(com.obsproject.Studio)$

          layerrule = blur on, match:namespace gtk-layer-shell
          layerrule = blur on, match:namespace logout_dialog
          windowrule = opacity 0.0 override, no_anim on, no_initial_focus on, max_size 1 1, no_blur on, match:class ^(xwaylandvideobridge)$
        '';

        "$mainMod" = "SUPER";
        bind = [
          "$mainMod, Q, killactive,"
          "$mainMod, M, exit"
          "$mainMod, E, exec, kitty yazi"
          "$mainMod, N, exec, kitty nvim"
          "$mainMod, V, togglefloating"
          "$mainMod, T, fullscreen"
          "$mainMod, $mainMod_L, exec, pkill rofi || rofi -show drun"
          "$mainMod, B, exec, firefox"
          "$mainMod, P, pseudo # dwindle"
          "$mainMod, J, togglesplit # dwindle"
          "$mainMod, X, exec, kitty"
          "$mainMod, O, exec, obs"
          "$mainMod, L, exec, pkill wlogout || wlogout"
          "$mainMod, C, exec, code"
          "$mainMod, Z, exec, zeditor"

          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod, A, movefocus, l"
          "$mainMod, D, movefocus, r"
          "$mainMod, W, movefocus, u"
          "$mainMod, S, movefocus, d"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "ALT,Tab,cyclenext"
          "ALT,Tab,bringactivetotop"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # Example special workspace (scratchpad)
          "$mainMod, F, togglespecialworkspace, magic"
          "$mainMod SHIFT, F, movetoworkspace, special:magic"
          "$mainMod CTRL, F, movetoworkspace, 1"

          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          #Function Keys Bindings
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86MonBrightnessUp, exec, brightnessctl -d intel_backlight s +10%"
          ", XF86MonBrightnessDown, exec, brightnessctl -d intel_backlight s 10%-"
          ", XF86PowerOff, exec, pkill wlogout || wlogout"

          # Custom Key Bindings
          "$mainMod, R, exec, ~/.config/waybar/scripts/launch.sh"
          "$mainMod SHIFT, H, exec, nixos-help"
          "$mainMod SHIFT, P, exec, firefox https://search.nixos.org/packages"

          # █▀ █▀▀ █▀█ █▀▀ █▀▀ █▄░█ █▀ █░█ █▀█ ▀█▀
          # ▄█ █▄▄ █▀▄ ██▄ ██▄ █░▀█ ▄█ █▀█ █▄█ ░█░
          # $screenshotarea = hyprctl keyword animation "fadeOut,0,0,default"; grimblast --notify copysave area; hyprctl keyword animation "fadeOut,1,4,default"
          "SUPER SHIFT, S, exec, grimblast --notify copysave area"
          ", Print, exec, grimblast --notify --cursor copysave output"
          "ALT, Print, exec, grimblast --notify --cursor copysave screen"
        ];

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
