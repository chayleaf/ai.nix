{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, huggingface-hub
, pyyaml
, safetensors
, torch
, torchvision
}:

buildPythonPackage rec {
  pname = "timm";
  version = "0.6.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NA+QeQZpUJLPU/4BpHaqFK0VdjVFtlS8Ei6g2u8jBx8=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    huggingface-hub
    pyyaml
    safetensors
    torch
    torchvision
  ];

  pythonImportsCheck = [ "timm" ];

  meta = with lib; {
    description = "PyTorch Image Models";
    homepage = "https://pypi.org/project/timm";
    license = licenses.asl20;
    maintainers = with maintainers; [ chayleaf ];
  };
}
