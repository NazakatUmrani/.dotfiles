{
  description = "Shopify dev shell with pinned cloudflared";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Older nixpkgs commit that contains cloudflared 2024.x
    nixpkgs-cloudflared.url = "github:NixOS/nixpkgs/1b03e7d8e5249f39972ec944e74e3be61411fac9";
  };

  outputs = { self, nixpkgs, nixpkgs-cloudflared }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };

      cloudflaredPkgs = import nixpkgs-cloudflared {
        inherit system;
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.nodejs_20
          pkgs.shopify-cli
          pkgs.nodePackages.pnpm

          # Dependendencies for prisma
          pkgs.openssl
          pkgs.prisma-engines

          # Pinned, Shopify-compatible cloudflared
          cloudflaredPkgs.cloudflared
        ];

        shellHook = ''
          export SHOPIFY_CLI_CLOUDFLARED_PATH=${cloudflaredPkgs.cloudflared}/bin/cloudflared

          echo "🛍️ Shopify Dev Shell Ready"
          echo "Node: $(node -v)"
          echo "Shopify CLI: $(shopify version)"
          echo "Cloudflared: $(${cloudflaredPkgs.cloudflared}/bin/cloudflared --version)"
        '';
      };
    };
}
