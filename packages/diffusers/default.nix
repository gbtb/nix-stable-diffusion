# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, filelock, huggingface-hub, importlib-metadata
, lib, numpy, pillow, regex, requests }:

buildPythonPackage rec {
  pname = "diffusers";
  version = "0.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k4f9zya92jv4msdm66jaab29avxd6ba9c7aqc2mp7sdycg7mdi9";
  };

  propagatedBuildInputs =
    [ importlib-metadata filelock huggingface-hub numpy regex requests pillow ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "Diffusers";
    homepage = "https://github.com/huggingface/diffusers";
  };
}
