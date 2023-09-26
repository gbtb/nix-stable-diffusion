# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, lib, numpy, packaging, psutil, pyyaml, torch }:

buildPythonPackage rec {
  pname = "accelerate";
  version = "0.21.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e2959a0bf74d97c0b3c0e036ed96065142a060242281d27970d4c4e34f11ca59";
  };

  propagatedBuildInputs = [ numpy packaging psutil pyyaml torch ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "Accelerate";
    homepage = "https://github.com/huggingface/accelerate";
  };
}
