{ buildPythonPackage, lib, numpy,  fetchFromGitHub, pillow, tqdm, setuptools, stdenv, pkg-config, opencv4 }:
let
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "mauwii";
    repo = "PyPatchMatch";
    rev = "release/v${version}";
    sha256 = "sha256-icxRmmxWvztQvMsYBJatvGa2YzxX05+xxdg+UJuy1SQ=";
  };
  libpatchmatch = stdenv.mkDerivation {
    name = "libpatchmatch";
    sourceRoot = ["source/patchmatch"];
    nativeBuildInputs = [
      pkg-config
      opencv4
    ];
    inherit src version;

    installPhase = ''
      mkdir -p $out/lib
      cp libpatchmatch.so $out/lib/
    '';
  };
in
buildPythonPackage {
  pname = "pypatchmatch";
  inherit src version;

  format = "pyproject";
  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ numpy pillow tqdm ];

  # TODO FIXME
  doCheck = false;

  postInstall = ''
    cp ${libpatchmatch}/lib/libpatchmatch.so $out/lib/*/site-packages/patchmatch/
  '';

  meta = {
    description = "This library implements the PatchMatch based inpainting algorithm";
    homepage = "https://github.com/invoke-ai/PyPatchMatch";
  };
}
