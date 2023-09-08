{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, starlette
}:

buildPythonPackage rec {
  pname = "fastapi-events";
  version = "0.6.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2380cdc3e30dc898d6b721d623c575c6f5b05ee35a3ee05adf0b90b12b9ed1f9";
  };

  propagatedBuildInputs = [
    starlette
  ];

  # TODO FIXME
  doCheck = false;
}
