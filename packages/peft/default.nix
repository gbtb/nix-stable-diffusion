{ buildPythonPackage, fetchPypi, lib
, numpy
, packaging
, psutil
, pyyaml
, torch
, transformers
, accelerate
}:
buildPythonPackage rec {
  pname = "peft";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bbdeee4de3653ee43cb6bbe7505816e6e9b4cf8275471be1707d9c253dfe8e0b";
  };

  propagatedBuildInputs = [
    numpy
    packaging
    psutil
    pyyaml
    torch
    transformers
    accelerate
  ];
  format = "pyproject";
  doCheck = false;
}
