{ lib
, fetchpatch
, python3
, fetchFromGitHub
, writeShellScript
, callPackage
, backend ? "rocm"
}:

let
  self = let
    inherit (python3.pkgs) buildPythonApplication;
  in
  buildPythonApplication {
    pname = "comfyui";
    version = "unstable-2024-06-27";
    # disabled = pythonOlder "3.9";

    src = fetchFromGitHub {
      owner = "comfyanonymous";
      repo = "ComfyUI";
      rev = "8ceb5a02a3182e6551690d9e56934bdca1cebcca";
      hash = "sha256-rAq5lXkgnfZiPFnbSYHd57MSWsvZFUXN2XqOoxyU6BA=";
    };

    propagatedBuildInputs = with python3.pkgs; [
      # requirements.txt
      torch
      torchsde
      torchvision
      torchaudio
      einops
      transformers
      safetensors
      aiohttp
      pyyaml
      pillow
      scipy
      tqdm
      psutil
    ]
    ++ lib.optionals true [
      # non essential dependencies:
      kornia
      spandrel
      soundfile
    ];

    patches = [
      ./paths-relative-to-cwd.patch
    ];

    postPatch = ''
      rm -rf models output temp input user tests tests-ui notebooks
      rm README.md LICENSE requirements.txt extra_model_paths.yaml.example CODEOWNERS comfyui_screenshot.png pytest.ini
      rm custom_nodes/*
    '';

    format = "other";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/${python3.sitePackages}/" "$out/bin"
      mv */ *.py "$out/${python3.sitePackages}/"
      echo "#!/usr/bin/env python3" > "$out/bin/comfyui"
      cat "$out/${python3.sitePackages}/main.py" >> "$out/bin/comfyui"
      chmod +x "$out/bin/comfyui"

      runHook postInstall
    '';

    meta = with lib; {
      description = "The most powerful and modular stable diffusion GUI, api and backend with a graph/nodes interface";
      homepage = "https://github.com/comfyanonymous/ComfyUI";
      license = licenses.gpl3;
      maintainers = with maintainers; [ chayleaf ];
    };

    passthru =
      let
        wrapper = callPackage ./wrapper.nix {
          inherit python3;
          unwrapped = self;
        };
      in
      {
        python = python3;

        customNodes = callPackage ./custom-nodes.nix { python = python3; };

        withPythonPackages = pythonPackages: wrapper { inherit pythonPackages; };

        withCustomNodes = customNodes: wrapper { inherit customNodes; };
      };
  };

in
  self
