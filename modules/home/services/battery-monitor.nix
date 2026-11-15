
{ config, lib, pkgs, ... }:

let
  batteryMonitor = pkgs.writeShellApplication {
    name = "battery-monitor";

    runtimeInputs = [
      pkgs.coreutils
      pkgs.libnotify
    ];

    text = ''
      set -euo pipefail

      # Find the battery automatically
      BATTERY_DIR=""

      for supply in /sys/class/power_supply/*; do
        if [[ -r "$supply/type" ]] &&
           [[ "$(< "$supply/type")" == "Battery" ]] &&
           [[ -r "$supply/capacity" ]]; then
          BATTERY_DIR="$supply"
          break
        fi
      done

      if [[ -z "$BATTERY_DIR" ]]; then
        echo "No battery found in /sys/class/power_supply/"
        exit 1
      fi

      # Persistent state
      STATE_HOME="''${XDG_STATE_HOME:-$HOME/.local/state}"
      STATE_DIR="$STATE_HOME/battery-monitor"
      STATE_FILE="$STATE_DIR/state"

      mkdir -p "$STATE_DIR"

      notify() {
        local urgency="$1"
        local title="$2"
        local message="$3"
        local replace_id="''${4:-}"

        if [[ -n "$replace_id" ]]; then
          dunstify \
            --appname="Battery Monitor" \
            --urgency="$urgency" \
            --replace="$replace_id" \
            "$title" "$message" || true
        else
          notify-send \
            --app-name="Battery Monitor" \
            --urgency="$urgency" \
            "$title" "$message" || true
        fi
      }

      # Detect AC / USB-C power connection
      read_online() {
        local found=0

        for supply in /sys/class/power_supply/*; do
          if [[ -r "$supply/online" ]]; then
            found=1

            if [[ "$(< "$supply/online")" == "1" ]]; then
              echo 1
              return
            fi
          fi
        done

        if (( found == 1 )); then
          echo 0
        else
          # Fallback for systems without an online attribute
          local status
          status="$(< "$BATTERY_DIR/status")"

          if [[ "$status" == "Charging" ||
                "$status" == "Full" ]]; then
            echo 1
          else
            echo 0
          fi
        fi
      }

      save_state() {
        printf '%s %s\n' "$1" "$2" > "$STATE_FILE"
      }

      get_interval() {
        local pct="$1"

        if (( pct <= 10 )); then
          echo 5
        elif (( pct <= 30 )); then
          echo 15
        else
          echo 60
        fi
      }

      # Initial battery reading
      pct="$(< "$BATTERY_DIR/capacity")"
      online="$(read_online)"

      # Initialize without generating false checkpoint alerts
      if [[ ! -r "$STATE_FILE" ]]; then
        prev_pct="$pct"
        prev_online="$online"

        if (( online == 0 && pct <= 10 )); then
          notify critical \
            "BATTERY LOW — CONNECT CHARGER" \
            "Monitor started at $pct%. Connect your charger and save your work!"

        elif (( online == 0 && pct <= 30 )); then
          notify normal \
            "Battery low" \
            "Monitor started at $pct%. Consider connecting your charger."
        fi

        save_state "$pct" "$online"
      else
        read -r prev_pct prev_online < "$STATE_FILE"
      fi

      echo "Battery monitor started: $pct%, online=$online"

      while true; do

        sleep 1

        pct="$(< "$BATTERY_DIR/capacity")"
        online="$(read_online)"

        # Charger connection / disconnection
        if (( prev_online == 0 && online == 1 )); then
          notify normal \
            "󰂄 Charger connected" \
            "Power adapter connected. Battery: $pct%." \
            9001

        elif (( prev_online == 1 && online == 0 )); then
          notify normal \
            "󰂃 Charger disconnected" \
            "Running on battery. Current charge: $pct%." \
            9001
        fi

        # Battery fully charged
        if (( online == 1 && prev_pct < 100 && pct >= 100 )); then
          notify normal \
            "Battery fully charged" \
            "Your battery has reached 100%."
        fi

        # Discharging checkpoints
        # Do not generate checkpoint notifications while charging
        if (( prev_online == 0 && online == 0 )); then

          for threshold in \
            90 80 70 60 50 40 \
            30 25 20 15 10 \
            9 8 7 6 5 4 3 2
          do

            if (( prev_pct > threshold && pct <= threshold )); then

              if (( threshold <= 5 )); then
                urgency="critical"
                title="BATTERY CRITICAL — $threshold%"
                message="CONNECT CHARGER NOW! Save your work immediately. Current battery: $pct%."

              elif (( threshold <= 10 )); then
                urgency="critical"
                title="Critical battery: $threshold%"
                message="Battery dropping rapidly. Connect your charger now!"

              else
                urgency="normal"
                title="Battery at $threshold%"
                message="Current battery level: $pct%."
              fi

              notify "$urgency" "$title" "$message"
            fi

          done
        fi

        prev_pct="$pct"
        prev_online="$online"

        save_state "$prev_pct" "$prev_online"

      done
    '';
  };

in
{
  home.packages = [ batteryMonitor ];

  systemd.user.services.battery-monitor = {
    Unit = {
      Description = "Adaptive Battery Monitoring and Dunst Notifications";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${batteryMonitor}/bin/battery-monitor";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
