# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "gradio";
  version = "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "123123123132";
  };

  propagatedBuildInputs =
    [ ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "Build Machine Learning Web Apps";
    homepage = "https://gradio.app/";
  };
}
