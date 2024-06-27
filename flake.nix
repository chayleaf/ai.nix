{
  description = "Nix compatibility for Maubot";

  inputs = {
    # pinned for rocm support
    nixpkgs.url = "github:NixOS/nixpkgs/ec8e05e7d374aa6186cdefd249ca434bc10b2362";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }:
    let
      forEachSystem = fn: nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ]
        (system: fn {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
          pkgsRocm = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.rocm ];
          };
          pkgsCuda = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.cuda ];
          };
        });
    in
    {
      overlays = let mkOverlay = 
        args @ { rocmSupport, cudaSupport }:
        final: prev: let
          python = prev.python3.override {
            packageOverrides = final.callPackage ./pkgs/python-overlay.nix args // {
            };
          };
        in rec {
          comfyui = final.callPackage ./pkgs/comfyui { };
          comfyui1 = comfyui.withCustomNodes (x: with x; [
            comfyui-tooling-nodes
            comfyui-inpaint-nodes
            ComfyUI_IPAdapter_plus
            comfyui_controlnet_aux
          ]);
          python3Packages = prev.python3Packages // python.pkgs;
          python3 = python;
        };
      in {
        default = mkOverlay { rocmSupport = false; cudaSupport = false; };
        rocm = mkOverlay { rocmSupport = true; cudaSupport = false; };
        cuda = mkOverlay { rocmSupport = false; cudaSupport = true; };
      };
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);
      packages = forEachSystem ({ pkgs, pkgsRocm, pkgsCuda }: {
        inherit pkgsRocm pkgsCuda;
        inherit (pkgs) comfyui;
        default = pkgs.comfyui;
      });
    };
}
