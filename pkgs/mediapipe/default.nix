{ lib
, python3
, bazel_6
, buildBazelPackage
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, absl-py
, attrs
, flatbuffers
, jax
, jaxlib
, matplotlib
, numpy
, opencv4
, protobuf
, sounddevice
}:

let
  version = "0.10.14";

  bazel-wheel = buildBazelPackage {
    name = "mediapipe-${version}-py2.py3-none-any.whl";
    src = fetchFromGitHub {
      owner = "google-ai-edge";
      repo = "mediapipe";
      rev = "v${version}";
      hash = "sha256-B3IdBD64OPy9IWKzIjTqbt/mgxAetqqEdLJFlXDt9NI=";
    };
    nativeBuildInputs = [
      # python3
      # setuptools
      # wheel
    ];

    bazel = bazel_6;

    # bazelTargets = [ ":" ];

    fetchAttrs.sha256 = lib.fakeSha256;

    buildAttrs = {
    #   preBuild = ''
    #     patchShebangs .
    #   '';
    #
    #   installPhase = ''
    #   '';
    };
  };

in
buildPythonPackage {
  pname = "mediapipe";
  inherit version;

  format = "wheel";
  src = bazel-wheel;

  propagatedBuildInputs = [
    absl-py
    attrs
    flatbuffers
    jax
    jaxlib
    matplotlib
    numpy
    opencv4
    protobuf
    sounddevice
  ];

  pythonImportsCheck = [ "mediapipe" ];

  meta = with lib; {
    description = "Cross-platform, customizable ML solutions for live and streaming media";
    homepage = "https://github.com/google-ai-edge/mediapipe";
    license = licenses.asl20;
    maintainers = with maintainers; [ chayleaf ];
  };
}
