{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, numpy
, opencv4
, pyyaml
, qudida
, scikit-image
, scipy
, deepdiff
, pythonOlder
, pythonRelaxDepsHook
, torch
, torchvision
, pydantic
}:

buildPythonPackage rec {
  pname = "albumentations";
  version = "1.4.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VNpClOBdoaQOqU92Mm/Z5Q7P+fZzR+m43SFA9pSi1M0=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRemoveDeps = [
    "opencv-python"
    "pydantic"
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    opencv4
    pyyaml
    qudida
    scikit-image
    scipy
    pydantic
  ];

  nativeCheckInputs = [
    deepdiff
    torch
    torchvision
  ];

  pythonImportsCheck = [ "albumentations" ];

  meta = with lib; {
    description = "Fast image augmentation library and easy to use wrapper around other libraries";
    homepage = "https://github.com/albumentations-team/albumentations";
    changelog = "https://github.com/albumentations-team/albumentations/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
