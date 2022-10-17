# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "opencv-python";
  version = "4.6.0.66";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n0ikysx365cn7l829v5jb819rfkzyia1i0fn5mycca0mm0sxgy5";
  };

  # TODO FIXME
  doCheck = false;

  meta = with lib; { };
}
