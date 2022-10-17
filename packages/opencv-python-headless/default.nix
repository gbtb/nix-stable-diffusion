# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "opencv-python-headless";
  version = "4.6.0.66";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1iacs1l6hi0y0p5zzmyjxj874qgq3bbg11pxnv51jb5a21z1safm";
  };

  # TODO FIXME
  doCheck = false;

  meta = with lib; { };
}
