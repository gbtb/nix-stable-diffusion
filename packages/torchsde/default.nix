# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ boltons, buildPythonPackage, fetchPypi, lib, numpy, scipy, torch, trampoline }:

buildPythonPackage rec {
  pname = "torchsde";
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0swhs2rp1hqi7qm55xh2rbcrz3qp8b2a1kvib95pmlqhavhyjar2";
  };

  propagatedBuildInputs = [ boltons numpy scipy torch trampoline ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description =
      "SDE solvers and stochastic adjoint sensitivity analysis in PyTorch.";
    homepage = "https://github.com/google-research/torchsde";
  };
}
