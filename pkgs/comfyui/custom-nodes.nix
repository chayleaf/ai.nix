{ python
, fetchFromGitHub
, stdenvNoCC
, opencv4
}:

let
  buildCustomNode = { pname, version, src, patches ? [], propagatedBuildInputs ? [ ] }: stdenvNoCC.mkDerivation {
    inherit pname version src patches propagatedBuildInputs;
    installPhase = ''
      runHook preInstall

      mkdir -p "$out/${python.sitePackages}/custom_nodes/${pname}"
      cp -r * "$out/${python.sitePackages}/custom_nodes/${pname}"

      runHook postInstall
    '';
  };
in
{
  inherit buildCustomNode;
  comfyui_controlnet_aux = buildCustomNode {
    pname = "comfyui_controlnet_aux";
    version = "1.0.1";
    src = fetchFromGitHub {
      owner = "Fannovel16";
      repo = "comfyui_controlnet_aux";
      rev = "589af18adae7ff50009a0e021781dd1aa39c32e3";
      hash = "sha256-J9sJAr+zj2+HNAMQGc9a1i2dcf863y8Hq/ORpLGVWOw=";
    };
    propagatedBuildInputs = with python.pkgs; let
      trimesh_easy = [
        colorlog
        mapbox-earcut
        chardet
        lxml
        jsonschema
        networkx
        svg-path
        pycollada
        setuptools
        shapely
        xxhash
        rtree
        httpx
        scipy
        # embreex
        pillow
        vhacdx
        xatlas
    ];
    in trimesh_easy ++ [
      torch
      importlib-metadata
      huggingface-hub
      scipy
      opencv4 # opencv-python
      filelock
      numpy
      pillow
      einops
      torchvision
      pyyaml
      scikit-image
      python-dateutil
      # mediapipe
      svglib
      fvcore
      yapf
      omegaconf
      ftfy
      addict
      yacs
      trimesh
      albumentations
      scikit-learn
      # for some more hw accel (segfaults)
      # onnxruntime
    ];
  };
  ComfyUI_IPAdapter_plus = buildCustomNode {
    pname = "ComfyUI_IPAdapter_plus";
    version = "unstable-2024-06-05";
    src = fetchFromGitHub {
      owner = "cubiq";
      repo = "ComfyUI_IPAdapter_plus";
      rev = "f904b4c3c3adbda990f32b90eb52e1924467c9ef";
      hash = "sha256-u3/8CLeJx1QrHPkvqCc6g87SlCR7zRCwnlux/Uz5Grw=";
    };
  };
  comfyui-tooling-nodes = buildCustomNode {
    pname = "comfyui-tooling-nodes";
    version = "unstable-2024-06-20";
    src = fetchFromGitHub {
      owner = "Acly";
      repo = "comfyui-tooling-nodes";
      rev = "aff32e8da6db5db73bc6f84b30c87862e211544c";
      hash = "sha256-6i1PGog8ZNBwO9FDFjneWRCx8Cn6N1N1hZhzI64GLNk=";
    };
  };
  comfyui-inpaint-nodes = buildCustomNode {
    pname = "comfyui-inpaint-nodes";
    version = "unstable-2024-06-14";
    src = fetchFromGitHub {
      owner = "Acly";
      repo = "comfyui-inpaint-nodes";
      rev = "9927f44cb4a9878f1737cbabf8a29d2fc8182d0f";
      hash = "sha256-FS+wDpDWboArBK2pq5Ye+eL3jNkxBoEnYnXt/TxKcKc=";
    };
  };
  ComfyUI_UltimateSDUpscale = buildCustomNode {
    pname = "ComfyUI_UltimateSDUpscale";
    version = "unstable-2024-08-16";
    src = fetchFromGitHub {
      owner = "ssitu";
      repo = "ComfyUI_UltimateSDUpscale";
      rev = "6ea48202a76ccf5904ddfa85f826efa80dd50520";
      hash = "sha256-fUZ0AO+LARa+x30Iu+8jvEDun4T3f9G0DOlB2XNxY9Q=";
      fetchSubmodules = true;
    };
  };
}
