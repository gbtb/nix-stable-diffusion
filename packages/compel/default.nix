# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, lib, torch, fetchFromGitHub, pyparsing, transformers, diffusers }:

buildPythonPackage rec {
  pname = "compel";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1617fd8ad0bd6c153a3bb4b63d921b1a77ebb649cd0c532f536180141e8ecd62";
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
