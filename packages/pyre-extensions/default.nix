# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, lib, typing-extensions, typing-inspect }:

buildPythonPackage rec {
  pname = "pyre-extensions";
  version = "0.0.30";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-unkjxIbgia+zehBiOo9K6C1zz/QkJtcRxIrwcOW8MbI=";
  };

  propagatedBuildInputs = [ typing-inspect typing-extensions ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "Type system extensions for use with the pyre type checker";
    homepage = "https://pyre-check.org";
  };
}
