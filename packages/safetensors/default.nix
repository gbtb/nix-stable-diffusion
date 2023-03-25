# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, lib, torch, fetchFromGitHub, pyparsing, transformers, diffusers, setuptools-rust, rustPlatform }:

buildPythonPackage rec {
  pname = "safetensors";
  version = "0.2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JyCyCmo4x5ncp5vXbK7qwvffWFqdT31Z+n4o7/nMsn8=";
  }; 

  pythonRemoveDeps = [ "setuptools-rust" ];
  nativeBuildInputs = [ setuptools-rust ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);
  propagatedBuildInputs = [ pyparsing torch transformers diffusers setuptools-rust ];
  sourceRoot = "${pname}-${version}";
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src sourceRoot;
    name = sourceRoot;
    hash = "sha256-ylpf82NXlpo4+u5HZVYeJI8I6VBFAukzC7Er6BZk1Ik=";
    patches = [ ./cargo-lock.patch ];
  };

  patches = [ ./cargo-lock.patch ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description =
      "A text prompt weighting and blending library for transformers-type text embedding systems";
    homepage = "https://pypi.org/project/compel/#description";
  };
}
