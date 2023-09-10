{ buildPythonPackage, fetchPypi, lib
, pythonRelaxDepsHook
, absl-py
, attrs
, flatbuffers
, matplotlib
, numpy
, opencv-contrib-python
, protobuf3
, sounddevice
}:
buildPythonPackage rec {
  pname = "mediapipe";
  version = "0.10.3";

  format = "wheel";

  src = fetchPypi {
    dist = "cp310";
    python = "cp310";
    abi = "cp310";
    platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
    inherit pname version format;
    sha256 = "e47cd06fe25a52add5c0bbcd8643c8b03677c98ff3a96f8e3c122ac148d63161";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = [
    "protobuf"
  ];
  pythonRemoveDeps = [ "opencv-contrib-python" ];
  propagatedBuildInputs = [
    absl-py
    attrs
    flatbuffers
    matplotlib
    numpy
    opencv-contrib-python
    protobuf3
    sounddevice
  ];
  doCheck = false;
}
