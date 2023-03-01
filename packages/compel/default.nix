# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ boltons, buildPythonPackage, fetchPypi, lib, numpy, scipy, torch, fetchFromGitHub, pyparsing, transformers, diffusers }:

buildPythonPackage rec {
  pname = "compel";
  version = "0.1.7";

  src = fetchFromGitHub {
    inherit pname version;
    owner = "damian0815";
    repo = pname;
    rev = "085d657356714fbc972f12273ec7803242d602a0";
    sha256 = "sha256-v6tkyOH0cBQWPPmi9AY9nvYwaT8QxNpJneB/YWSdlYc=";
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
