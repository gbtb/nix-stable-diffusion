# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ accelerate, buildPythonPackage, clip-anytorch, einops, fetchPypi, jsonmerge
, kornia, lib, pillow, resize-right, scikit-image, scipy, torch, torchdiffeq
, torchvision, tqdm, wandb, clean-fid, torchsde }:

buildPythonPackage rec {
  pname = "k-diffusion";
  version = "0.0.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-b7mxIA64tClz96s78GCI+kBJf/umi2ClCNjDYlqjTrs=";
  };

  propagatedBuildInputs = [
    accelerate
    clip-anytorch
    einops
    jsonmerge
    kornia
    pillow
    resize-right
    scikit-image
    scipy
    torch
    torchdiffeq
    torchvision
    torchsde
    tqdm
    wandb
    clean-fid
  ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; { };
}
