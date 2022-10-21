{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "fonts";
  version = "0.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "277e6c5312355c70de910ac253b8a46f6b2a65a1492dcfab1b8e88fb0c872c18";
  };

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "A Python framework for distributing and managing fonts.";
    homepage = "https://github.com/pimoroni/fonts-python";
  };
}
