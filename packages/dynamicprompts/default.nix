{ buildPythonPackage, fetchFromGitHub, lib
, hatchling
, pyparsing
, jinja2
}:
buildPythonPackage rec {
  pname = "dynamicprompts";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "adieyal";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uAwuZr7mXFMlsMP2GhbbybfP7LeORWPROox4Gf/OjOs=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    pyparsing
    jinja2
  ];

  format = "pyproject";
}
