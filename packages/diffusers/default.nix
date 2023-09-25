# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, filelock, huggingface-hub, importlib-metadata
, lib, numpy, pillow, regex, requests }:

buildPythonPackage rec {
  pname = "diffusers";
  version = "0.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4cd7400382c86d85e08425550de1b1a81d4ed03623fbd4bcd8377864d9c46efe";
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
