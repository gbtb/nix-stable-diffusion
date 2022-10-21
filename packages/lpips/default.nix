# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, lib, numpy, tqdm, scipy, torch
  , torchvision }:

buildPythonPackage rec {
  pname = "lpips";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "OEYzHfbGloiuw9MApe7vbFKUNbyEYL1YIBw9YuVhiPo=";
  };

  propagatedBuildInputs =
    [ numpy tqdm scipy torch torchvision ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "Perceptual Similarity Metric and Dataset";
    homepage = "https://richzhang.github.io/PerceptualSimilarity/";
  };
}
