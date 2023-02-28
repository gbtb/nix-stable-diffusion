{ buildPythonPackage, lib, numpy,  fetchFromGitHub, pillow, tqdm, setuptools }:

buildPythonPackage rec {
  pname = "pypatchmatch";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "invoke-ai";
    repo = "PyPatchMatch";
    rev = version;
    sha256 = "sha256-PemWmujCMVzKF3/BL0jrL+z5KCKIertrYLAwf/+ZySs=";
  };

  format = "pyproject";
  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ numpy pillow tqdm ];

  # TODO FIXME
  doCheck = false;

  meta = {
    description = "This library implements the PatchMatch based inpainting algorithm";
    homepage = "https://github.com/invoke-ai/PyPatchMatch";
  };
}
