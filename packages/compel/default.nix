# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, lib, torch, fetchFromGitHub, pyparsing, transformers, diffusers }:

buildPythonPackage rec {
  pname = "compel";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e9de64b6ea5f9df59f8fae7ebad9a57d1f369dcc953c8645880a49bb19c2c7c";
  };

  propagatedBuildInputs = [ pyparsing torch transformers diffusers ];
  format = "pyproject";

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description =
      "A text prompt weighting and blending library for transformers-type text embedding systems";
    homepage = "https://pypi.org/project/compel/#description";
  };
}
