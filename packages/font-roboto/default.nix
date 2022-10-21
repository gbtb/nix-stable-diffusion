{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "font-roboto";
  version = "0.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xiZlW3WmBxXhGOROJwZW/SL9j1QlKQH/br8TCK0BxAU=";
  };

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "Roboto is a neo-grotesque sans-serif font family designed by Google for the Android mobile OS.";
    homepage = "https://github.com/pimoroni/fonts-python";
  };
}
