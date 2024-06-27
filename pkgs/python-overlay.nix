{ rocmSupport
, cudaSupport
}:

final: prev: {
  pytorch = prev.pytorch.override { inherit rocmSupport cudaSupport; };
  torch = prev.torch.override { inherit rocmSupport cudaSupport; };
  torchaudio = final.callPackage ./torchaudio { inherit rocmSupport cudaSupport; };
  spandrel = final.callPackage ./spandrel { };
  mediapipe = final.callPackage ./mediapipe { };
  embreex = final.callPackage ./embreex { };
  vhacdx = final.callPackage ./vhacdx { };
  xatlas = final.callPackage ./xatlas { };
  albumentations = final.callPackage ./albumentations { };
}
