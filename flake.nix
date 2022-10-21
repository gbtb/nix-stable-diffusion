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
      requirements = pkgs: with pkgs; with pkgs.python3.pkgs; [
        python3

        torch
        torchvision
        numpy

        addict
        future
        lmdb
        pyyaml
        scikitimage
        tqdm
        yapf
        gdown
        lpips
        fastapi
        lark
        analytics-python
        ffmpy
        markdown-it-py
        shap
        gradio
        fonts

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
        clip
        k-diffusion
        gfpgan
      ];
      overlay_default = nixpkgs: pythonPackages:
        {
          pytorch-lightning = pythonPackages.pytorch-lightning.overrideAttrs (old: {
            nativeBuildInputs = old.nativeBuildInputs ++ [ nixpkgs.python3Packages.pythonRelaxDepsHook ];
            pythonRelaxDeps = [ "protobuf" ];
          });
          wandb = pythonPackages.wandb.overrideAttrs (old: {
            nativeBuildInputs = old.nativeBuildInputs ++ [ nixpkgs.python3Packages.pythonRelaxDepsHook ];
            pythonRelaxDeps = [ "protobuf" ];
          });
          streamlit = nixpkgs.streamlit.overrideAttrs (old: {
            nativeBuildInputs = old.nativeBuildInputs ++ [ nixpkgs.python3Packages.pythonRelaxDepsHook ];
            pythonRelaxDeps = [ "protobuf" ];
          });
          scikit-image = pythonPackages.scikitimage;
        };
      overlay_pynixify = self:
        let
          rm = d: d.overrideAttrs (old: {
            nativeBuildInputs = old.nativeBuildInputs ++ [ self.pythonRelaxDepsHook ];
            pythonRemoveDeps = [ "opencv-python-headless" "opencv-python" "tb-nightly" ];
          });
          callPackage = self.callPackage;
          rmCallPackage = path: args: rm (callPackage path args);
        in
        rec {

          pydeprecate = callPackage ./packages/pydeprecate { };
          taming-transformers-rom1504 = callPackage ./packages/taming-transformers-rom1504 { };
          albumentations = rmCallPackage ./packages/albumentations { opencv-python-headless = self.opencv4; };
          qudida = rmCallPackage ./packages/qudida { opencv-python-headless = self.opencv4; };
          gfpgan = rmCallPackage ./packages/gfpgan { opencv-python = self.opencv4; };
          basicsr = rmCallPackage ./packages/basicsr { opencv-python = self.opencv4; };
          facexlib = rmCallPackage ./packages/facexlib { opencv-python = self.opencv4; };
          realesrgan = rmCallPackage ./packages/realesrgan { opencv-python = self.opencv4; };
          filterpy = callPackage ./packages/filterpy { };
          kornia = callPackage ./packages/kornia { };
          lpips = callPackage ./packages/lpips { };
          ffmpy = callPackage ./packages/ffmpy { };
          shap = callPackage ./packages/shap { };
          fonts = callPackage ./packages/fonts { };
          analytics-python = callPackage ./packages/analytics-python { };
          markdown-it-py = callPackage ./packages/markdown-it-py { };
          gradio = callPackage ./packages/gradio { };
          torch-fidelity = callPackage ./packages/torch-fidelity { };
          resize-right = callPackage ./packages/resize-right { };
          torchdiffeq = callPackage ./packages/torchdiffeq { };
          k-diffusion = callPackage ./packages/k-diffusion { clean-fid = self.clean-fid; };
          accelerate = callPackage ./packages/accelerate { };
          clip-anytorch = callPackage ./packages/clip-anytorch { };
          jsonmerge = callPackage ./packages/jsonmerge { };
          clean-fid = callPackage ./packages/clean-fid { };
        };
      overlay_amd = nixpkgs: pythonPackages:
        rec {
          torch-bin = pythonPackages.torch-bin.overrideAttrs (old: {
            src = nixpkgs.fetchurl {
              name = "torch-1.12.1+rocm5.1.1-cp310-cp310-linux_x86_64.whl";
              url = "https://download.pytorch.org/whl/rocm5.1.1/torch-1.12.1%2Brocm5.1.1-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-kNShDx88BZjRQhWgnsaJAT8hXnStVMU1ugPNMEJcgnA=";
            };
          });
          torchvision-bin = pythonPackages.torchvision-bin.overrideAttrs (old: {
            src = nixpkgs.fetchurl {
              name = "torchvision-0.13.1+rocm5.1.1-cp310-cp310-linux_x86_64.whl";
              url = "https://download.pytorch.org/whl/rocm5.1.1/torchvision-0.13.1%2Brocm5.1.1-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-mYk4+XNXU6rjpgWfKUDq+5fH/HNPQ5wkEtAgJUDN/Jg=";
            };
          });
          torch = torch-bin;
          torchvision = torchvision-bin;
        };
    in
    {

      devShells = forAll
        (system:
          let
            nixpkgs_ = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true; #both CUDA and MKL are unfree
              overlays = [
                (final: prev: {
                  python3 = prev.python3.override {
                    packageOverrides =
                      python-self: python-super:
                      (overlay_default prev python-super) //
                      (overlay_amd prev python-super) //
                      (overlay_pynixify python-self);
                      #((import ./pynixify/overlay.nix) python-self python-super);
                  };
                })
              ];
            };
          in
          rec {
            invokeai-amd = nixpkgs_.mkShell
            (let
              lapack = nixpkgs_.lapack.override { lapackProvider = nixpkgs_.mkl; };
              blas = nixpkgs_.lapack.override { lapackProvider = nixpkgs_.mkl; };
            in
            {
              name = "invokeai-amd";
              propagatedBuildInputs = requirements nixpkgs_;
              shellHook = ''
                #on my machine SD segfaults somewhere inside scipy with openblas, so I had to use another blas impl
                #build of scipy with non-default blas is broken, therefore overriding lib in runtime

                export NIXPKGS_ALLOW_UNFREE=1
                export LD_LIBRARY_PATH=${lapack}/lib:${blas}/lib

              '';
            });
            default = invokeai-amd;
          });
    };
}
