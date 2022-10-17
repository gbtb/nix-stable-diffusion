{
  description = "A very basic flake";

  inputs = {
    nixlib.url = "github:nix-community/nixpkgs.lib";
    nixpkgs = {
      url = "github:NixOS/nixpkgs?rev=fd54651f5ffb4a36e8463e0c327a78442b26cbe7";
    };
  };
  outputs = { self, nixpkgs, nixlib }@inputs:
    let
      nixlib = inputs.nixlib.outputs.lib;
      supportedSystems = [ "x86_64-linux" ];
      forAll = nixlib.genAttrs supportedSystems;
    in
    {

      devShells = forAll
        (system:
          let
            nixpkgs_ = import inputs.nixpkgs {
              inherit system;
              overlays = [
                (final: prev: {
                  #blas = prev.blas.override {
                  #  blasProvider = final.mkl;
                  #};
                  #lapack = prev.lapack.override {
                  #  lapackProvider = final.mkl;
                  #};
                  python3 = prev.python3.override {
                    packageOverrides =
                      python-self: python-super: {
                        pytorch-lightning = python-super.pytorch-lightning.overrideAttrs (old: {
                          nativeBuildInputs = old.nativeBuildInputs ++ [ prev.python3Packages.pythonRelaxDepsHook ];
                          pythonRelaxDeps = [ "protobuf" ];
                        });
                        #numpy = python-super.numpy.override { blas = prev.mkl; };
                        wandb = python-super.wandb.overrideAttrs (old: {
                          nativeBuildInputs = old.nativeBuildInputs ++ [ prev.python3Packages.pythonRelaxDepsHook ];
                          pythonRelaxDeps = [ "protobuf" ];
                        });
                        torch-bin = python-super.torch-bin.overrideAttrs (old: {
                          src = prev.fetchurl {
                            name = "torch-1.12.1+rocm5.1.1-cp310-cp310-linux_x86_64.whl";
                            url = "https://download.pytorch.org/whl/rocm5.1.1/torch-1.12.1%2Brocm5.1.1-cp310-cp310-linux_x86_64.whl";
                            hash = "sha256-kNShDx88BZjRQhWgnsaJAT8hXnStVMU1ugPNMEJcgnA=";
                          };
                        });
                        torchvision-bin = python-super.torchvision-bin.overrideAttrs (old: {
                          src = prev.fetchurl {
                            name = "torchvision-0.13.1+rocm5.1.1-cp310-cp310-linux_x86_64.whl";
                            url = "https://download.pytorch.org/whl/rocm5.1.1/torchvision-0.13.1%2Brocm5.1.1-cp310-cp310-linux_x86_64.whl";
                            hash = "sha256-mYk4+XNXU6rjpgWfKUDq+5fH/HNPQ5wkEtAgJUDN/Jg=";
                          };
                        });
                        streamlit = prev.streamlit.overrideAttrs (old: {
                          nativeBuildInputs = old.nativeBuildInputs ++ [ prev.python3Packages.pythonRelaxDepsHook ];
                          pythonRelaxDeps = [ "protobuf" ];
                        });
                      } //
                      ((import ./pynixify/overlay.nix) python-self python-super);
                  };
                })
              ];
            };
          in
          {
            default = nixpkgs_.mkShell
              {
                name = "stable-diffusion-flake";
                propagatedBuildInputs = with nixpkgs_; with nixpkgs_.python3.pkgs; [
                  python3
                  pip
                  virtualenv

                  torch-bin
                  torchvision
                  numpy

                  albumentations
                  opencv4
                  pudb
                  imageio
                  imageio-ffmpeg
                  pytorch-lightning
                  protobuf3_20
                  omegaconf
                  realesrgan
                  test-tube
                  streamlit
                  send2trash
                  pillow
                  einops
                  taming-transformers-rom1504
                  torch-fidelity
                  transformers
                  torchmetrics
                  flask
                  flask-socketio
                  flask-cors
                  dependency-injector
                  eventlet
                  kornia
                  clip #?
                  k-diffusion
                  gfpgan
                ];
              };
          });
    };
}
