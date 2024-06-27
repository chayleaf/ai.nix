{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, numpy
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "embreex";
  version = "2.17.7.post4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trimesh";
    repo = "embreex";
    rev = version;
    hash = "sha256-L9ymfzZXodUdUDD+F6cjIXECcHjJmWVH+TO9ls5+TdI=";
  };

  nativeBuildInputs = [
    cython
    numpy
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
  ];

  pythonImportsCheck = [ "embreex" ];

  meta = with lib; {
    description = "Python Wrapper for Embree";
    homepage = "https://github.com/trimesh/embreex";
    license = licenses.bsd2;
    maintainers = with maintainers; [ chayleaf ];
  };
}
