# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "scikit-image";
  version = "0.19.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l645smf7w1kail70z8d9r3xmvz7qh6g7n3d2bpacbbnw5ykdd94";
  };

  # TODO FIXME
  doCheck = false;

  meta = with lib; { };
}
