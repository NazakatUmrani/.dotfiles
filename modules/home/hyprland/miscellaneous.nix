{ config, lib, ... }:
let
  lua = lib.generators.mkLuaInline;
in
{
  options.my.hyprland = {
    monitor = lib.mkOption {
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

    enableAnimations = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    enableBlur = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    enableShadow = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    enableBorders = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      # plugins = [
      #   hyprplugins.hyprtrails
      # ];
      # extraConfig = " ";
      configType = "lua";

      settings = {
        env = [
          { _args = [ "NIXOS_OZONE_WL" "1"]; }
          { _args = [ "XDG_CURRENT_DESKTOP" "Hyprland"]; }
          { _args = [ "XDG_SESSION_TYPE" "wayland"]; }
          { _args = [ "XDG_SESSION_DESKTOP" "Hyprland"]; }
          { _args = [ "GDK_BACKEND" "wayland, x11"]; }
          { _args = [ "CLUTTER_BACKEND" "wayland"]; }
          { _args = [ "QT_QPA_PLATFORM" "wayland;xcb"]; }
          { _args = [ "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1"]; }
          { _args = [ "QT_AUTO_SCREEN_SCALE_FACTOR" "1"]; }
          { _args = [ "SDL_VIDEODRIVER" "x11"]; }
          { _args = [ "MOZ_ENABLE_WAYLAND" "1"]; }
          { _args = [ "ELECTRON_OZONE_PLATFORM_HINT" "wayland"]; } # This is to make electron apps start in wayland
          { _args = [ "GDK_SCALE" "1"]; }
          { _args = [ "QT_SCALE_FACTOR" "1"]; }
          { _args = [ "TERMINAL" "kitty"]; }
          { _args = [ "XDG_TERMINAL_EMULATOR" "kitty"]; }
          #  { _args = [ "XCURSOR_SIZE" "24"]; } # Commenting out for now to see if it affects
        ];

        on = {
          _args = [
            "hyprland.start"
            (lua ''
              function()
                hl.exec_cmd("awww-daemon --format xrgb")
                hl.exec_cmd("awww img $wallpaper --transition-step 255")
                hl.exec_cmd("wl-paste --type text --watch cliphist store")
                hl.exec_cmd("wl-paste --type image --watch cliphist store")
                hl.exec_cmd("dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
                hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
                hl.exec_cmd("systemctl --user start hyprpolkitagent")
                hl.exec_cmd("waybar")
                hl.exec_cmd("dunst")
                hl.exec_cmd("nm-applet --indicator")
                hl.exec_cmd("bash -c \"wl-paste --watch cliphist store &\"")
              end
            '')
          ];
        };

        animations = lib.mkIf config.my.hyprland.enableAnimations {
          enabled = true;
          bezier = [
            "wind, -1.05, 0.9, 0.1, 1.05"
            "winIn, -1.1, 1.1, 0.1, 1.1"
            "winOut, -1.3, -0.3, 0, 1"
            "liner, 0, 1, 1, 1"
          ];
          animation = [
            "windows, 0, 6, wind, slide"
            "windowsIn, 0, 6, winIn, slide"
            "windowsOut, 0, 5, winOut, slide"
            "windowsMove, 0, 5, wind, slide"
            "border, 0, 1, liner"
            "fade, 0, 10, default"
            "workspaces, 0, 5, wind"
          ];
        };

        gesture = [
          { fingers = 3; direction = "horizontal"; action = "workspace"; }
        ];

        config = {
          cursor = {
            no_hardware_cursors = 1;
            warp_on_change_workspace = 2;
            no_warps = true;
          };

          decoration = lib.mkMerge [
            { }
            (lib.mkIf config.my.hyprland.enableBlur {
              blur = {
                enabled = true;
                size = 4;
                passes = 4;
                ignore_opacity = true;
                new_optimizations = true;
              };
              active_opacity = 0.95;
              inactive_opacity = 0.7;
            })

            (lib.mkIf config.my.hyprland.enableShadow {
              shadow = {
                enabled = true;
                range = 4;
                render_power = 3;
                color = "rgba(1a1a1aee)";
              };
            })

            (lib.mkIf config.my.hyprland.enableBorders {
              rounding = 10;
            })
          ];

          dwindle = {
            preserve_split = true;
            smart_resizing = true;
            use_active_for_splits = true;
            smart_split = true;
            split_bias = 0;
            precise_mouse_move = false;
            special_scale_factor = 0.8;
          };

          general = {
            layout = "dwindle";
            gaps_in = 3;
            gaps_out = 9;
          }
          // lib.mkIf config.my.hyprland.enableBorders {
            border_size = 2;
            "col.active_border" = {
                colors = [
                  "rgba(fb4934ee)"
                  "rgba(fabd2fee)"
                ];
                angle = 45;
              };
            "col.inactive_border" = { colors = [ "rgba(595959aa)" ]; angle = 45; };
          };

          gestures = {
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
        
          # Ensure Xwayland windows render at integer scale; compositor scales them
          xwayland = {
            force_zero_scaling = true;
          };
        };


        monitor = config.my.hyprland.monitor;


        window_rule = [
          {
            match.class = "^(firefox)$";
            idle_inhibit = "fullscreen";
          }
          {
            match.class = "^(mpv)$";
            idle_inhibit = "focus";
          }
          {
            match.class = "^(wlogout)$";
            idle_inhibit = "fullscreen";
          }
          {
            match.class = "^(Waydroid)$";
            idle_inhibit = "fullscreen";
          }

          # Floating & Positioning
          # NOT WORKING - Need to find out fixes in future
          # {
          #   match.title = "^(Volume Control)$";
          #   float = true;
          #   maximize = false;
          #   default_position = {
          #     x = 0;
          #     y = 0;
          #     anchor = "center";
          #   };
          # }

          # Workspace 1: Terminal
          {
            match.class = "^(kitty)$";
            workspace = 1;
          }

          # Workspace 2: File Managers
          {
            match.class = "^(org.kde.dolphin)$";
            workspace = 2;
          }
          {
            match.class = "^(thunar)$";
            workspace = 2;
          }
          {
            match.class = "^(lf)$";
            workspace = 2;
          }

          # Workspace 3: Browsers & Chat
          {
            match.class = "^(google-chrome)$";
            workspace = 3;
          }
          {
            match.class = "^(firefox)$";
            workspace = 3;
          }
          {
            match.class = "^(discord)$";
            workspace = 3;
          }

          # Workspace 4: Editors & IDEs
          
          {
            match.class = "^(code)$";
            workspace = 4;
          }
          {
            match.class = "^(dev.zed.Zed)$";
            workspace = 4;
          }
          {
            match.class = "^(jetbrains-studio)$";
            workspace = 4;
          }
          
          # Workspace 5: Gaming & Emulators
          # Zenity for Heroic install prefixes window
          {
            match.class = "^(zenity)$";
            workspace = 5;
          }
          {
            match.class = "^(steam)$";
            workspace = 5;
          }
          {
            match.class = "^(steam_app_.*)$";
            workspace = 5;
            fullscreen = true;
          }
          {
            match.title = "^(Emulator)$";
            workspace = 5;
          }

          # Workspace 6: Streaming & Remote Desktop
          {
            match.class = "^(com.obsproject.Studio)$";
            workspace = 6;
          }
          {
            match.initial_class = "^(org.remmina.Remmina)$";
            workspace = 6;
          }

          # Workspace 10: System Utilities
          {
            match.initial_class = "^(.blueman-manager-wrapped)$";
            workspace = 10;
          }

          # XWayland Video Bridge
          {
            match.class = "^(xwaylandvideobridge)$";
            opacity = "0.0 override";
            no_anim = true;
            no_initial_focus = true;
            max_size = "1 1";
            no_blur = true;
          }
        ]
        ++ (map (title: {
          # Dialogs
          match.title = "^(${title})(.*)$";
          float = true;
        }) [
          "Library"
          "Open File"
          "Open Folder"
          "Save As"
          "Save File"
          "Select a File"
          "Extract"
          ".*Properties"
          "Media viewer"
          "Picture-in-Picture"
          "Authentication Required — PolicyKit1 KDE Agent"
        ])
        ++ (map (class: {
          # Utilities
          match.class = "^(${class})$";
          float = true;
          # pin = true;
          # persistent_size = true;
        }) [
          "file_progress"
          "confirm"
          "dialog"
          "download"
          "notification"
          "error"
          "splash"
          "confirmreset"
          "Open"
          "Save"
          "Open"
          "branchdialog"
          "Lxappearance"
          "wofi"
          "viewnior"
          "pavucontrol-qt"
          "pavucontrol"
          # feh
          # file-roller
        ]);

        layer_rule = [
          {
            match.namespace = "^gtk-layer-shell$";
            blur = true;
          }
          {
            match.namespace = "^logout_dialog$";
            blur = true;
          }
        ];
      };
    };

    # xdg.configFile."hypr" = {
    #   source = ../../configs/hypr;
    #   recursive = true;
    # };
  };
}
