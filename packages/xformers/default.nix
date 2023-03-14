# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, lib, torch, numpy, pyre-extensions, pythonRelaxDepsHook, which }:

buildPythonPackage rec {
  pname = "xformers";
  version = "0.0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ksfwVWpo9EhkkmkbP1ZxQO4ZK1Y9kEGFtmabH4u4rlM=";
  };
  nativeBuildInputs = [ pythonRelaxDepsHook which ];
  pythonRelaxDeps = [ "pyre-extensions" ];
  propagatedBuildInputs = [ torch numpy pyre-extensions /*triton*/ ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; { };
}
