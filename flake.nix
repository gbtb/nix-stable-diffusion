{
  description = "A very basic flake";

  inputs = {
    nixlib.url = "github:nix-community/nixpkgs.lib";
    nixpkgs = {
      url = "github:NixOS/nixpkgs"; #?rev=33919d25f0c873b0c73e2f8d0859fab3bd0d1b26";
    };
    stable-diffusion-repo = {
      url = "github:CompVis/stable-diffusion?rev=69ae4b35e0a0f6ee1af8bb9a5d0016ccb27e36dc";
      flake = false;
    };
    invokeai-repo = {
      url = "github:invoke-ai/InvokeAI?ref=v2.3.1.post2";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, nixlib, stable-diffusion-repo, invokeai-repo }@inputs:
    let
      nixlib = inputs.nixlib.outputs.lib;
      system = "x86_64-linux";
      requirementsFor = { pkgs, webui ? false }: with pkgs; with pkgs.python3.pkgs; [
        python3

        torch
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
        test-tube
        streamlit
        einops
        taming-transformers-rom1504
        torch-fidelity
        torchmetrics
        transformers
        kornia
        k-diffusion
        diffusers

        # following packages not needed for vanilla SD but used by both UIs
        realesrgan
        pillow
      ]
      ++ nixlib.optional (!webui) [
        npyscreen
        huggingface-hub
        dnspython
        datasets
        click
        pypatchmatch
        torchsde
        trampoline
        compel
        send2trash
        flask
        flask-socketio
        flask-cors
        dependency-injector
        gfpgan
        eventlet
        clipseg
        getpass-asterisk
      ]
      ++ nixlib.optional webui [
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
          scikit-image = pythonPackages.scikitimage;
        };
      overlay_webui = nixpkgs: pythonPackages:
        {
          transformers = pythonPackages.transformers.overrideAttrs (old: {
            src = nixpkgs.fetchFromGitHub {
              owner = "huggingface";
              repo = "transformers";
              rev = "refs/tags/v4.19.2";
              hash = "sha256-9r/1vW7Rhv9+Swxdzu5PTnlQlT8ofJeZamHf5X4ql8w=";
            };
          });
        };
      overlay_pynixify = self:
        let
          rm = d: d.overrideAttrs (old: {
            nativeBuildInputs = old.nativeBuildInputs ++ [ self.pythonRelaxDepsHook ];
            pythonRemoveDeps = [ "opencv-python-headless" "opencv-python" "tb-nightly" "clip" ];
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
          clipseg = rmCallPackage ./packages/clipseg { opencv-python = self.opencv4; };
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
          getpass-asterisk = callPackage ./packages/getpass-asterisk { };
          pypatchmatch = callPackage ./packages/pypatchmatch { };
          trampoline = callPackage ./packages/trampoline { };
          torchsde = callPackage ./packages/torchsde { };
          compel = callPackage ./packages/compel { };
          diffusers = callPackage ./packages/diffusers { };
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
        };
      overlay_nvidia = nixpkgs: pythonPackages:
        {
          torch = pythonPackages.torch-bin;
          torchvision = pythonPackages.torchvision-bin;
        };
    in
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
                streamlit = prev.streamlit.overrideAttrs (old: {
                  nativeBuildInputs = old.nativeBuildInputs ++ [ prev.python3Packages.pythonRelaxDepsHook ];
                  pythonRelaxDeps = [ "protobuf" ];
                });
                python3 = prev.python3.override {
                  packageOverrides =
                    python-self: python-super:
                    (overlay_default prev python-super) //
                    optional amd (overlay_amd prev python-super) //
                    optional nvidia (overlay_nvidia prev python-super) //
                    optional webui (overlay_webui prev python-super) //
                    (overlay_pynixify python-self);
                };
              })
          ];
        };
    in
    {
      packages.${system} =
        {
          invokeai = {
            amd = 
              inputs.nixpkgs.legacyPackages.${system}.python3Packages.buildPythonApplication {
                pname = "invokeai";
                version = "2.3.1";
                src = invokeai-repo;
                format = "pyproject";
                propagatedBuildInputs = requirementsFor { pkgs = (nixpkgs_ { amd = true; }); };
            };
          };
        };
      devShells.${system} =
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
                (
                  let args = { pkgs = (nixpkgs_ { webui = true; }); webui = true; }; in
                  {
                    shellHook = shellHookFor args.pkgs;
                    name = "webui";
                    propagatedBuildInputs = requirementsFor args.pkgs;
                  }
                );
              amd = mkShell
                (
                  let args = { pkgs = (nixpkgs_ { webui = true; amd = true; }); webui = true; }; in
                  {
                    shellHook = shellHookFor args.pkgs;
                    name = "webui.amd";
                    propagatedBuildInputs = requirementsFor args;
                  }
                );
              nvidia = mkShell
                (
                  let args = { pkgs = (nixpkgs_ { webui = true; nvidia = true; }); webui = true; }; in
                  {
                    shellHook = shellHookFor args.pkgs;
                    name = "webui.nvidia";
                    propagatedBuildInputs = requirementsFor args;
                  }
                );
            };
          default = invokeai.amd;
        };
    };
}
