{ config, ... }:
{
  programs.nvf = {
    enable = true;
    # your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
      vim = {
        viAlias = false; # sets vi alias to open nvim
        vimAlias = false; # sets vim alias to open nvim

        options.shiftwidth = 2;

        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;

        lsp = {
          enable = true;
        };

        languages = {
          enableTreesitter = true;

          # Language Support
          nix.enable = true;
          html.enable = true;
          css.enable = true;
          tailwind.enable = true;
          ts.enable = true;
          json.enable = true;
        };
      };
    };
  };
}
