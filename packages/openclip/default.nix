# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage
, fetchFromGitHub
, ftfy
, huggingface-hub
, lib
, regex
, sentencepiece
, torch
, torchvision
, tqdm
, protobuf
}:

buildPythonPackage rec {
  pname = "open_clip";
  version = "2.7.0";

  src = fetchFromGitHub { 
    owner = "mlfoundations";
    repo = "open_clip";
    rev = "v2.7.0";
    sha256 = "sha256-QzEGSUe2c+LkWb2rwTavQAvcllbrjAtgF/RwbzwOfnU=";
  };

  propagatedBuildInputs = [
    torch
    torchvision
    regex
    ftfy
    tqdm
    huggingface-hub
    sentencepiece
    protobuf
  ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "OpenCLIP";
    homepage = "https://github.com/mlfoundations/open_clip";
  };
}
