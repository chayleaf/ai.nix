{ rocmSupport
, cudaSupport
}:

final: prev: {
  pytorch = prev.pytorch.override { inherit rocmSupport cudaSupport; };
  torch = prev.torch.override { inherit rocmSupport cudaSupport; };
  torchaudio = final.callPackage ./torchaudio { inherit rocmSupport cudaSupport; };
  controlnet-aux = final.callPackage ./controlnet-aux { };
  spandrel = final.callPackage ./spandrel { };
  mediapipe = final.callPackage ./mediapipe { };
  embreex = final.callPackage ./embreex { };
  timm = final.callPackage ./timm { };
  typer-config = final.callPackage ./typer-config { };
  vhacdx = final.callPackage ./vhacdx { };
  xatlas = final.callPackage ./xatlas { };
  albumentations = final.callPackage ./albumentations { };
  gradio = final.callPackage ./gradio { };
  gradio-client = final.callPackage ./gradio/client.nix { };
}
