{ config, pkgs, ... }:

{
  programs = {
    lf = {
      enable = true;
      commands = {
        # Changed from xdragon to dragon-out which gives 2 options: xdragon and dragon-drop, right now using xdragon, not sure about dragon-drop yet
        dragon-out = ''%${pkgs.dragon-drop}/bin/xdragon -a -x "$fx"'';
        editor-open = "$$EDITOR $f";
        mkdir = ''
          ''${{
            printf "Directory Name: "
            read DIR
            mkdir $DIR
          }}
        '';
      };
      keybindings = {
        "\\\"" = "";
        o = "";
        c = "mkdir";
        "." = "set hidden!";
        "`" = "mark-load";
        "\\'" = "mark-load";
        "<enter>" = "open";

        do = "dragon-out";

        "g~" = "cd";
        gh = "cd";
        "g/" = "/";

        ee = "editor-open";
        V = ''''$${pkgs.bat}/bin/bat --paging=always --theme=gruvbox "$f"'';
        dd = "delete";
        # ...
      };

      settings = {
        preview = true;
        drawbox = true;
        icons = true;
        ignorecase = true;
      };

      extraConfig =
        let
          previewer = pkgs.writeShellScriptBin "pv.sh" ''
            file=$1
            w=$2
            h=$3
            x=$4
            y=$5

            if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
                ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
                exit 1
            fi

            ${pkgs.pistol}/bin/pistol "$file"
          '';
          cleaner = pkgs.writeShellScriptBin "clean.sh" ''
            ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
          '';
        in
        ''
          set cleaner ${cleaner}/bin/clean.sh
          set previewer ${previewer}/bin/pv.sh
        '';
    };
  };
}
