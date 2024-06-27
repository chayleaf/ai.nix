{ lib
, buildPythonPackage
, fetchFromGitHub
, pybind11
, setuptools
, wheel
, numpy
, pytest
}:

buildPythonPackage {
  pname = "vhacdx";
  version = "unstable-2024-06-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trimesh";
    repo = "vhacdx";
    rev = "189487ec09cd51062810a81d8b644d69ca695731";
    hash = "sha256-1nBcDLKyLrYmfk41gBZ/YeUzgpeT76HjeytsCQ5IrFM=";
  };

  nativeBuildInputs = [
    pybind11
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
  ];

  passthru.optional-dependencies = {
    test = [
      pytest
    ];
  };

  pythonImportsCheck = [ "vhacdx" ];

  meta = with lib; {
    description = "Python bindings for V-HACD";
    homepage = "https://github.com/trimesh/vhacdx/";
    license = licenses.mit;
    maintainers = with maintainers; [ chayleaf ];
  };
}
