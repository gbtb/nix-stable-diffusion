{
  description = "A very basic flake";

  inputs = {
    nixlib.url = "github:nix-community/nixpkgs.lib";
    nixpkgs = {
      url = "github:NixOS/nixpkgs?rev=fd54651f5ffb4a36e8463e0c327a78442b26cbe7";
    };
    stable-diffusion-repo = {
      url = "github:CompVis/stable-diffusion?rev=69ae4b35e0a0f6ee1af8bb9a5d0016ccb27e36dc";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, nixlib, stable-diffusion-repo }@inputs:
    let
      nixlib = inputs.nixlib.outputs.lib;
      supportedSystems = [ "x86_64-linux" ];
      forAll = nixlib.genAttrs supportedSystems;
      requirementsFor = { pkgs, webui ? false }: with pkgs; with pkgs.python3.pkgs; [
        python3

        torch
        torchvision
        numpy

        # TODO: split SD and InvokeAI deps
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
      ] ++ nixlib.optional webui [
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
        font-roboto
        piexif
        websockets
        codeformer
        blip
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
        rec        {

          pydeprecate = callPackage ./packages/pydeprecate { };
          taming-transformers-rom1504 =
            callPackage ./packages/taming-transformers-rom1504 { };
          albumentations = rmCallPackage ./packages/albumentations { opencv-python-headless = self.opencv4; };
          qudida = rmCallPackage ./packages/qudida { opencv-python-headless = self.opencv4; };
          gfpgan = rmCallPackage ./packages/gfpgan { opencv-python = self.opencv4; };
          basicsr = rmCallPackage ./packages/basicsr { opencv-python = self.opencv4; };
          facexlib = rmCallPackage ./packages/facexlib { opencv-python = self.opencv4; };
          realesrgan = rmCallPackage ./packages/realesrgan { opencv-python = self.opencv4; };
          codeformer = callPackage ./packages/codeformer { opencv-python = self.opencv4; };
          filterpy = callPackage ./packages/filterpy { };
          kornia = callPackage ./packages/kornia { };
          lpips = callPackage ./packages/lpips { };
          ffmpy = callPackage ./packages/ffmpy { };
          shap = callPackage ./packages/shap { };
          fonts = callPackage ./packages/fonts { };
          font-roboto = callPackage ./packages/font-roboto { };
          analytics-python = callPackage ./packages/analytics-python { };
          markdown-it-py = callPackage ./packages/markdown-it-py { };
          gradio = callPackage ./packages/gradio { };
          hatch-requirements-txt = callPackage ./packages/hatch-requirements-txt { };
          timm = callPackage ./packages/timm { };
          blip = callPackage ./packages/blip { };
          fairscale = callPackage ./packages/fairscale { };
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
          #overriding because of https://github.com/NixOS/nixpkgs/issues/196653
          opencv4 = pythonPackages.opencv4.override { openblas = nixpkgs.blas; };
        };
      overlay_nvidia = nixpkgs: pythonPackages:
        {
          torch = pythonPackages.torch.override {
            cudaSupport = true;
          };
        };
    in
    {
      devShells = forAll
        (system:
          let
            mkShell = inputs.nixpkgs.legacyPackages.${system}.mkShell;
            nixpkgs_ = { amd ? false, nvidia ? false, webui ? false }:
              import inputs.nixpkgs {
                inherit system;
                config.allowUnfree = nvidia; #CUDA is unfree.
                overlays = [
                  (final: prev:
                    let optional = nixlib.optionalAttrs; in
                    {
                      python3 = prev.python3.override {
                        packageOverrides =
                          python-self: python-super:
                          (overlay_default prev python-super) //
                          optional amd (overlay_amd prev python-super) //
                          optional nvidia (overlay_amd prev python-super) //
                          (overlay_pynixify python-self);
                      };
                    })
                ];
              };
          in
          rec {
            invokeai =
              let
                shellHook = ''
                  cd InvokeAI
                '';
              in
              {
                default = mkShell
                  ({
                    inherit shellHook;
                    name = "invokeai";
                    propagatedBuildInputs = requirementsFor { pkgs = (nixpkgs_ { }); };
                  });
                amd = mkShell
                  ({
                    inherit shellHook;
                    name = "invokeai.amd";
                    propagatedBuildInputs = requirementsFor { pkgs = (nixpkgs_ { amd = true; }); };
                  });
                nvidia = mkShell
                  ({
                    inherit shellHook;
                    name = "invokeai.nvidia";
                    propagatedBuildInputs = requirementsFor { pkgs = (nixpkgs_ { nvidia = true; }); };
                  });
              };
            webui =
              let
                shellHookFor = nixpkgs:
                  let
                    submodel = pkg: nixpkgs.pkgs.python3.pkgs.${pkg} + "/lib/python3.10/site-packages";
                    taming-transformers = submodel "taming-transformers-rom1504";
                    k_diffusion = submodel "k-diffusion";
                    codeformer = (submodel "codeformer") + "/codeformer";
                    blip = (submodel "blip") + "/blip";
                  in
                  ''
                    cd stable-diffusion-webui
                    git reset --hard HEAD
                    git apply ${./webui.patch}
                    rm -rf repositories/
                    mkdir repositories
                    ln -s ${inputs.stable-diffusion-repo}/ repositories/stable-diffusion
                    substituteInPlace modules/paths.py \
                      --subst-var-by taming_transformers ${taming-transformers} \
                      --subst-var-by k_diffusion ${k_diffusion} \
                      --subst-var-by codeformer ${codeformer} \
                      --subst-var-by blip ${blip}
                  '';
              in
              {
                default = mkShell
                  ({
                    shellHook = shellHookFor (nixpkgs_ { });
                    name = "webui";
                    propagatedBuildInputs = requirementsFor { pkgs = (nixpkgs_ { }); webui = true; };
                  });
                amd = mkShell
                  ({
                    shellHook = shellHookFor (nixpkgs_ { amd = true; });
                    name = "webui.amd";
                    propagatedBuildInputs = requirementsFor { pkgs = (nixpkgs_ { amd = true; }); webui = true; };
                  });
                nvidia = mkShell
                  ({
                    shellHook = shellHookFor (nixpkgs_ { nvidia = true; });
                    name = "webui.nvidia";
                    propagatedBuildInputs = requirementsFor { pkgs = (nixpkgs_ { nvidia = true; }); webui = true; };
                  });
              };
            default = invokeai.amd;
          });
    };
}
