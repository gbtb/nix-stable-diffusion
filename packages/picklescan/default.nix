# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, lib, wheel, setuptools }:

buildPythonPackage rec {
  pname = "picklescan";
  version = "0.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z87dswh1hljgxw2q11zss5vfdi7qj3kfqrj22dlngpq7qa3d3xf";
  };

  # TODO FIXME
  doCheck = false;

  propagatedBuildInputs = [ setuptools wheel ];
  format = "pyproject";

  meta = with lib; { };
}
