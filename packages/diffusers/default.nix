# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, filelock, huggingface-hub, importlib-metadata
, lib, numpy, pillow, regex, requests, safetensors }:

buildPythonPackage rec {
  pname = "diffusers";
  version = "0.19.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5311357288d54e43a604cc5559200ec1d6e56bd9912d3563bf6c955a414232e6";
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
