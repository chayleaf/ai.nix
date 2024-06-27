{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, ninja
, setuptools
, wheel
, numpy
, pytest
, trimesh
}:

buildPythonPackage rec {
  pname = "xatlas";
  version = "0.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mworchel";
    repo = "xatlas-python";
    rev = "v${version}";
    hash = "sha256-8CQAqaD0BGtDEW1jlyoiQ0Lzj2Bspoaw3a3ucyKYPJM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    setuptools
    wheel
  ];

  dontUseCmakeConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;

  propagatedBuildInputs = [
    numpy
  ];

  passthru.optional-dependencies = {
    test = [
      pytest
      trimesh
    ];
  };

  pythonImportsCheck = [ "xatlas" ];

  meta = with lib; {
    description = "Python bindings for xatlas";
    homepage = "https://github.com/mworchel/xatlas-python";
    license = licenses.mit;
    maintainers = with maintainers; [ chayleaf ];
  };
}
