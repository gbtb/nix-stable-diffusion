# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, filelock, huggingface-hub, importlib-metadata
, lib, numpy, pillow, regex, requests, safetensors }:

buildPythonPackage rec {
  pname = "diffusers";
  version = "0.20.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fadcf9feeff174f4c10d539ecfffc46e1ae014d5d6294000dabebe3938a5180d";
  };

  propagatedBuildInputs =
    [ importlib-metadata filelock huggingface-hub numpy regex requests pillow safetensors ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "Diffusers";
    homepage = "https://github.com/huggingface/diffusers";
  };
}
