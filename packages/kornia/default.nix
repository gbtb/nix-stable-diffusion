# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, lib, packaging, pytest-runner, torch }:

buildPythonPackage rec {
  pname = "kornia";
  version = "0.6.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ALTomQtczcWJ4+zCYTRGYjsP+y/h21WYqsVVE7QBaQM=";
  };

  buildInputs = [ pytest-runner ];
  propagatedBuildInputs = [ packaging torch ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; { };
}
