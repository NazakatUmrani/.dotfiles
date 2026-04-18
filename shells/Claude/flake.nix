{
  description = "Dev shell with Node, npm, pnpm, yarn and Claude Code";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true; # sometimes needed
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          # Node ecosystem
          nodejs_20 # LTS
          pnpm
          yarn

          # Dev tools
          git
          curl
          wget
          jq
          ripgrep
          fd

          # Build tools (helps npm packages)
          python3
          gcc
          gnumake

          # Your requirement
          claude-code
        ];

        shellHook = ''
          echo "🚀 Dev shell (25.11) ready"
          echo "Node: $(node -v)"
          echo "npm: $(npm -v)"
          echo "pnpm: $(pnpm -v)"
        '';
      };
    };
}
