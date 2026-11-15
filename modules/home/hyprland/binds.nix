{ lib, ... }:
let
  lua = lib.generators.mkLuaInline;
  mainMod = "SUPER";

  dsp = {
    exec = cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';
    close = lua "hl.dsp.window.close()";
    focus_workspace = workspace: lua ''hl.dsp.focus({ workspace = "${workspace}"})'';
    focus_direction = direction: lua ''hl.dsp.focus({ direction = "${direction}"})'';
    move = workspace: lua "hl.dsp.window.move({ workspace = ${workspace}})";
    drag = lua "hl.dsp.window.drag()";
    resize = lua "hl.dsp.window.resize()";
    togglespecialworkspace = workspace: lua ''hl.dsp.workspace.toggle_special("${workspace}")'';
    fullscreen = lua "hl.dsp.window.fullscreen()";
    exit = lua "hl.dsp.exit()"; # quit Hyprland. It’s recommended to use hyprshutdown instead of this.
    kill = window: lua ''hl.dsp.window.kill("${window}")'';
    float = lua ''hl.dsp.window.float()'';
  };

  bind = keys: dispatcher: { _args = [ keys dispatcher ]; };
  bindr = keys: dispatcher: { _args = [ keys dispatcher { release = true; } ]; };
  bindl = keys: dispatcher: { _args = [ keys dispatcher { locked = true; } ]; };
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        # Lock screen on laptop lid switch
        (bindl "switch:on:Lid Switch" (dsp.exec "swaylock"))
        
        (bind "${mainMod} + Q" (dsp.close))
        # (bind "${mainMod} + M" (dsp.exec "exit"))
        (bind "${mainMod} + E" (dsp.exec "kitty yazi"))
        (bind "${mainMod} + N" (dsp.exec "kitty nvim"))
        (bind "${mainMod} + V" (dsp.float))
        (bind "${mainMod} + T" (dsp.fullscreen))
        # (bind "${mainMod} + $mainMod_L" (dsp.exec "pkill rofi || rofi -show drun"))
        (bindr "${mainMod} + SUPER_L" (dsp.exec "pkill rofi || rofi -show drun"))
        (bind "${mainMod} + B" (dsp.exec "firefox"))
        (bind "${mainMod} + P" (dsp.exec "pseudo")) # dwindle
        (bind "${mainMod} + J" (dsp.exec "layoutmsg, togglesplit")) # dwindle
        (bind "${mainMod} + X" (dsp.exec "kitty"))
        (bind "${mainMod} + O" (dsp.exec "obs"))
        (bind "${mainMod} + L" (dsp.exec "pkill wlogout || wlogout"))
        (bind "${mainMod} + C" (dsp.exec "code"))
        (bind "${mainMod} + Z" (dsp.exec "zeditor"))

        (bind "${mainMod} + F" (dsp.togglespecialworkspace "magic"))
        (bind "${mainMod} + SHIFT + F" (dsp.move ''"special:magic"''))
        (bind "${mainMod} + CTRL + F" (dsp.move "1"))
        # Cycle
        (bind "ALT + TAB" (dsp.exec "cyclenext"))
        (bind "ALT + TAB" (dsp.exec "bringactivetotop"))

        # Move focus with mainMod + arrow keys
        (bind "${mainMod} + left" (dsp.focus_direction "l"))
        (bind "${mainMod} + right" (dsp.focus_direction "r"))
        (bind "${mainMod} + up" (dsp.focus_direction "u"))
        (bind "${mainMod} + down" (dsp.focus_direction "d"))
        
        (bind "${mainMod} + A" (dsp.focus_direction "l"))
        (bind "${mainMod} + D" (dsp.focus_direction "r"))
        (bind "${mainMod} + W" (dsp.focus_direction "u"))
        (bind "${mainMod} + S" (dsp.focus_direction "d"))

        # Scroll through existing workspaces with mainMod + scroll
        (bind "${mainMod} + mouse_down" (dsp.focus_workspace "e+1"))
        (bind "${mainMod} + mouse_up" (dsp.focus_workspace "e-1"))

        # Custom Key Bindings
        (bind "${mainMod} + R" (dsp.exec "~/.config/waybar/scripts/launch.sh"))
        (bind "${mainMod} + SHIFT + H" (dsp.exec "nixos-help"))
        (bind "${mainMod} + SHIFT + P" (dsp.exec "firefox https://search.nixos.org/packages"))

        # █▀ █▀▀ █▀█ █▀▀ █▀▀ █▄░█ █▀ █░█ █▀█ ▀█▀
        # ▄█ █▄▄ █▀▄ ██▄ ██▄ █░▀█ ▄█ █▀█ █▄█ ░█░
        # $screenshotarea = hyprctl keyword animation "fadeOut,0,0,default"; grimblast --notify copysave area; hyprctl keyword animation "fadeOut,1,4,default"
        (bind "${mainMod} + SHIFT + S" (dsp.exec "grimblast --notify copysave area"))
        (bind "PRINT" (dsp.exec "grimblast --notify --cursor copysave output"))
        (bind "ALT + PRINT" (dsp.exec "grimblast --notify --cursor copysave screen"))

        #Function Keys Bindings
        (bind "XF86AudioRaiseVolume" (dsp.exec "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"))
        (bind "XF86AudioLowerVolume" (dsp.exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
        (bind "XF86AudioMute" (dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
        (bind "XF86AudioMicMute" (dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
        (bind "XF86MonBrightnessUp" (dsp.exec "brightnessctl -e4 -n2 set 5%+"))
        (bind "XF86MonBrightnessDown" (dsp.exec "brightnessctl -e4 -n2 set 5%-"))
        (bind "XF86AudioPlay" (dsp.exec "playerctl play-pause"))
        (bind "XF86AudioPause" (dsp.exec "playerctl play-pause"))
        (bind "XF86AudioNext" (dsp.exec "playerctl next"))
        (bind "XF86AudioPrev" (dsp.exec "playerctl previous"))
        (bind "XF86PowerOff" (dsp.exec "pkill wlogout || wlogout"))

        # Move/resize windows with mainMod + LMB/RMB and dragging
        # As clicking and moving the mouse on a touchpad is unergonomic, you can also use keyboard keys instead of mouse clicks.
        (bind "${mainMod} + mouse:272" (dsp.drag))
        (bind "${mainMod} + CTRL_L" (dsp.resize))
        (bind "${mainMod} + mouse:273" (dsp.drag))
        (bind "${mainMod} + ALT_L" (dsp.resize))
      ]
        ++ builtins.concatLists (map (i:
        let
          key = toString (lib.mod i 10);
          workspace = toString i;
        in [
          (bind "${mainMod} + ${key}" (dsp.focus_workspace workspace))
          (bind "${mainMod} + SHIFT + ${key}" (dsp.move workspace))
        ]
      ) (lib.range 1 10));
    };
  };
}
