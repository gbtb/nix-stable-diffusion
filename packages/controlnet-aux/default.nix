{ buildPythonPackage, fetchPypi, lib
, pillow
, torch
, numpy
, filelock
, importlib-metadata
, opencv-python
, matplotlib
, scipy
, huggingface-hub
, einops
, timm
, torchvision
, scikit-image
}:
buildPythonPackage rec {
  pname = "controlnet-aux";
  version = "0.0.6";

  src = fetchPypi {
    inherit version;
    pname = "controlnet_aux";
    sha256 = "1bec9a4aeff7eacccfaf8b86e744012ecc186e218e386ef21032780766f894fc";
  };


  propagatedBuildInputs = [
    pillow
    torch
    numpy
    filelock
    importlib-metadata
    opencv-python
    matplotlib
    scipy
    huggingface-hub
    einops
    timm
    torchvision
    scikit-image
  ];
  doCheck = false;
}
