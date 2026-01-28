# Shopify Development Shell for NixOS

This repository contains a **Nix flake dev shell** designed specifically for Shopify app development on NixOS. It sets up a reproducible development environment with the correct versions of **Node.js**, **Shopify CLI**, and **Cloudflared** to avoid common issues with NixOS immutability and Shopify's strict dependency expectations.

---

## Why this setup exists

Shopify CLI and its associated tooling make certain assumptions that conflict with NixOS:

1. **Immutable filesystem conflicts**:  
   - Shopify CLI uses **Cloudflared** to expose apps via HTTPS tunnels.  
   - Cloudflared normally tries to download its own binary or write configs to system directories.  
   - On NixOS, these directories are **read-only**, causing errors like `EROFS: Read-only file system`.

2. **Version-specific dependencies**:  
   - Shopify CLI is **strictly coupled to specific Cloudflared versions** (e.g., 2024.8.2).  
   - Using the default NixOS channel version (2025.x) triggers Shopify CLI to attempt a fallback download, which fails on read-only paths.

3. **Global installs are discouraged**:  
   - Shopify docs recommend `npm install -g @shopify/cli`, which conflicts with NixOS philosophy.  
   - This setup keeps all dependencies **fully reproducible and isolated** within the Nix dev shell.

---

## What this dev shell provides

- **Node.js 20** — Shopify-compatible LTS version  
- **Shopify CLI** — for app creation, management, and development  
- **Cloudflared pinned to 2024.8.2** — avoids Shopify CLI tunnel errors  
- **Prisma** — ORM used in shopify default initialized project
- **Openssl** — required by prisma
- **Environment variable `SHOPIFY_CLI_CLOUDFLARED_PATH`** pointing to pinned Cloudflared  
- Fully reproducible, **no global installs**, no mutable system paths

---

## How it works

1. **Multiple nixpkgs inputs**:
   - `nixos-25.11` for Node.js and Shopify CLI  
   - Older `nixpkgs` commit to pin Cloudflared to 2024.8.2  

2. **Pinned Cloudflared**:
   - Ensures Shopify CLI uses a compatible binary  
   - Prevents fallback downloads and read-only filesystem errors  

3. **Shell hook**:
   - Automatically sets `SHOPIFY_CLI_CLOUDFLARED_PATH`  
   - Prints Node, Shopify CLI, and Cloudflared versions for verification

---

## Usage

1. Copy the `flake.nix` and `flake.lock`.

2. Enter the dev shell by running:
```
nix develop
```
3. Start your Shopify app:

```
npm run dev
```
The tunnel should now work without EROFS errors.

---

Known issues

Shopify CLI may still rely on hidden Ruby tooling for some theme commands. Use only when necessary.

Cloudflared tunnel must run inside the shell or point SHOPIFY_CLI_CLOUDFLARED_PATH to another writable location if needed.

If Shopify CLI updates to require a newer Cloudflared version, you will need to pin a new compatible version in this flake.

---

References
[Shopify Community Discussion on NixOS & Cloudflare EROFS](https://community.shopify.dev/t/how-to-run-shopify-app-dev-on-nixos-cloudflare-erofs-rate-limiting/25956)
