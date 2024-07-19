{ lib
, python3
, fetchPypi
, opencv4
}:

python3.pkgs.buildPythonApplication rec {
  pname = "iopaint";
  version = "1.3.3";
  pyproject = true;

  src = fetchPypi {
    pname = "IOPaint";
    inherit version;
    hash = "sha256-Flow/vuKgwEPGiaroTdNvHUDl1Z97JhT3QhqtRzAPqA=";
  };

  postPatch = "touch requirements.txt";

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  pythonRemoveDeps = [ "opencv-python" ];

  propagatedBuildInputs = with python3.pkgs; [
    accelerate
    controlnet-aux
    diffusers
    easydict
    fastapi
    gradio
    loguru
    omegaconf
    opencv4 # opencv-python
    peft
    piexif
    pillow
    pydantic
    python-multipart
    python-socketio
    rich
    safetensors
    torch
    transformers
    typer
    typer-config
    uvicorn
    yacs
  ];

  pythonImportsCheck = [ "iopaint" ];

  meta = with lib; {
    description = "Image inpainting, outpainting tool powered by SOTA AI Model";
    homepage = "https://pypi.org/project/iopaint";
    license = licenses.asl20;
    maintainers = with maintainers; [ chayleaf ];
    mainProgram = "iopaint";
  };
}
