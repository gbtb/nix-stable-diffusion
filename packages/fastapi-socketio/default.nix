{ lib
, buildPythonPackage
, fetchPypi
, fastapi
, python-socketio
}:

buildPythonPackage rec {
  pname = "fastapi-socketio";
  version = "0.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "202f9b319f010001cbd1114ec92a0d9eb5f5ca9316eae5fd41a6088da0812727";
  };

  propagatedBuildInputs = [
    fastapi
    python-socketio
  ];

  # TODO FIXME
  doCheck = false;
}
