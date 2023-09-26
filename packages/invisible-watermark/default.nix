{ buildPythonPackage, fetchFromGitHub, lib
, opencv-python
, torch
, pillow
, pywavelets
, numpy
}:
buildPythonPackage rec {
  pname = "invisible-watermark";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ShieldMnt";
    repo = pname;
    rev = "bd1a4d54a993a3730c007148b328334250020082";
    hash = "sha256-hOPyISe4zVh+vZ3o5TFzxUQ9pLeDxUkE5WjhMR8eOYk=";
  };

  propagatedBuildInputs = [
    opencv-python
    torch
    pillow
    pywavelets
    numpy
  ];
  doCheck = false;
}
