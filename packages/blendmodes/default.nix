# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ aenum, buildPythonPackage, deprecation, fetchPypi, lib, numpy, pillow }:

buildPythonPackage rec {
  pname = "blendmodes";
  version = "2022";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00zx3025rlpgdsy78znm9xqml3kfd41sq34gjss391qfx70z2s4k";
  };

  propagatedBuildInputs = [ pillow aenum deprecation numpy ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description =
      "Use this module to apply a number of blending modes to a background and foreground image";
    homepage = "https://github.com/FHPythonUtils/BlendModes";
  };
}
