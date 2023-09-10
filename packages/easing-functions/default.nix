{ buildPythonPackage, fetchPypi, lib
}:
buildPythonPackage rec {
  pname = "easing-functions";
  version = "1.0.4";

  src = fetchPypi {
    inherit version;
    pname = "easing_functions";
    sha256 = "e18c7931d445b85f28c4d15ad0a9a47bb65d4e2eefc0db3840448fae25e3f9de";
  };
}
