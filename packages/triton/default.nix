# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchFromGitHub, lib, cmake, fetchPypi, llvm }:

buildPythonPackage rec {
  pname = "triton";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "triton";
    rev = "v${version}";
    sha256 = "sha256-9GZzugab+Pdt74Dj6zjlEzjj4BcJ69rzMJmqcVMxsKU=";
  };
  #sourceRoot = ["source/python"];

  LLVM_ROOT_DIR="${llvm}";
  nativeBuildInputs = [ cmake llvm ]; #llvm clang git ];
  #propagatedBuildInputs = [ torch filelock ncurses zlib pybind11 cmake-py ];

  /* postConfigure = '' */
  /*   cd .. */
  /* ''; */
  /*  */

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "A language and compiler for custom Deep Learning operations";
    homepage = "https://github.com/openai/triton/";
    # there are no mlir support for LLVM in nixpkgs (yet). Don't think it's worth to pull in unfinished PRs and force users recompile half of llvm. After all, triton support is nice to have, not mandatory.
    # https://github.com/NixOS/nixpkgs/pull/163878
    # https://github.com/openai/triton/issues/1154#issuecomment-1419455783
    broken = true;
  };
}
