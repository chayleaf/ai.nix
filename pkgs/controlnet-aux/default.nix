{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, einops
, filelock
, huggingface-hub
, importlib-metadata
, numpy
, opencv4
, pillow
, scikit-image
, scipy
, timm
, torch
, torchvision
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "controlnet-aux";
  version = "0.0.9";
  pyproject = true;

  src = fetchPypi {
    pname = "controlnet_aux";
    inherit version;
    hash = "sha256-bCg1Lm/pszJNaxKI2U0cJYbG4vyfWN+eRyl+pqhv1WA=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
    pythonRelaxDepsHook
  ];

  pythonRemoveDeps = [ "opencv-python-headless" ];

  propagatedBuildInputs = [
    einops
    filelock
    huggingface-hub
    importlib-metadata
    numpy
    opencv4 # opencv-python-headless
    pillow
    scikit-image
    scipy
    timm
    torch
    torchvision
  ];

  pythonImportsCheck = [ "controlnet_aux" ];

  meta = with lib; {
    description = "Auxillary models for controlnet";
    homepage = "https://pypi.org/project/controlnet-aux/";
    license = licenses.asl20;
    maintainers = with maintainers; [ chayleaf ];
  };
}
