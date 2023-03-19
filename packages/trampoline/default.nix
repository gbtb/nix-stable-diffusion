# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ boltons, buildPythonPackage, fetchPypi, lib, numpy, scipy, torch, fetchFromGitLab }:

buildPythonPackage rec {
  pname = "trampoline";
  version = "0.1.2";

  src = fetchFromGitLab {
    inherit pname version;
    owner = "ferreum";
    repo = pname;
    rev = "6ff003ed89abc4b64587227d10a6a8ba48309a83";
    sha256 = "sha256-1GK0MOF1uHhbT8qUQzr32B5HY8x3Nc0SvkjP0C21V6k=";
  };

  propagatedBuildInputs = [ ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description =
      "This trampoline allows recursive functions to recurse virtually (or literally) infinitely. Most existing recursive functions can be converted with simple modifications.";
    homepage = "https://pypi.org/project/trampoline/#description";
  };
}
