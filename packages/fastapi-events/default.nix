{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastapi-events";
  version = "0.8.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "55e7bf487e5c895e44630c11f0b12bd04e52aa8ecafcdc14ff9a4de4fb1cdf90";
  };

  # TODO FIXME
  doCheck = false;
}
