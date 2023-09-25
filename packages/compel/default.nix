# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, lib, torch, fetchFromGitHub, pyparsing, transformers, diffusers }:

buildPythonPackage rec {
  pname = "compel";
  version = "1.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "932a4448553983db33f4893516239ed5001b384cc211e32841e80b1f94dcd0f6";
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
