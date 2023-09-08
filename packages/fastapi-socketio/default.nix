{ lib
, buildPythonPackage
, fetchPypi
, fastapi
, python-socketio
}:

buildPythonPackage rec {
  pname = "fastapi-socketio";
  version = "0.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c73aa94fe1bf1c9964ff89233a6ba52eeeec3ac8b9de0024d9d82b11e46bde5";
  };

  propagatedBuildInputs = [
    fastapi
    python-socketio
  ];

  # TODO FIXME
  doCheck = false;
}
