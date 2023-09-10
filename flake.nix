{
  description = "Nix Flake for runnig Stable Diffusion on NixOS";

  inputs = {
    nixlib.url = "github:nix-community/nixpkgs.lib";
    nixpkgs = {
      url = "github:NixOS/nixpkgs"; #?rev=33919d25f0c873b0c73e2f8d0859fab3bd0d1b26";
    };
    stable-diffusion-repo = {
      url = "github:Stability-AI/stablediffusion?rev=47b6b607fdd31875c9279cd2f4f16b92e4ea958e";
      flake = false;
    };
    invokeai-repo = {
      url = "github:invoke-ai/InvokeAI?ref=v3.0.2post1";
      flake = false;
    };
    webui-repo = {
      #url = "github:AUTOMATIC1111/stable-diffusion-webui"; 
      url = "github:gbtb/stable-diffusion-webui"; #instead of patching in flake, better use a fork. CRLF bullshit makes patching this repo almost impossible
      flake = false;
    };
  };
  outputs = { self, nixpkgs, nixlib, stable-diffusion-repo, invokeai-repo, webui-repo }@inputs:
    let
      nixlib = inputs.nixlib.outputs.lib;
      system = "x86_64-linux";
      requirementsFor = { pkgs, webui ? false, nvidia ? false }: with pkgs; with pkgs.python3.pkgs; [
        python3
        torch
        torchvision
        numpy
        albumentations
        opencv4
        pudb
        pytorch-lightning
        omegaconf
        test-tube
        streamlit
        einops
        taming-transformers-rom1504
        torch-fidelity
        torchmetrics
        transformers
        diffusers
        # following packages not needed for vanilla SD but used by both UIs
        realesrgan
        pillow
        safetensors
        fastapi
      ]
      ++ nixlib.optional (nvidia) [ xformers ] #probably won't fully work
      ++ nixlib.optional (!webui) [
        npyscreen
        huggingface-hub
        dnspython
        datasets
        click
        pypatchmatch
        torchsde
        compel
        send2trash
        flask
        flask-socketio
        flask-cors
        eventlet
        clipseg
        picklescan
        peft
        packaging
        python-multipart
        fastapi-socketio
        fastapi-events
        dynamicprompts
        controlnet-aux
        easing-functions
        invisible-watermark
        matplotlib
        mediapipe
        onnx
        onnxruntime
        pydantic
        pympler
        pyperclip
        uvicorn
        uvicorn.optional-dependencies.standard
        rich
        test-tube
        protobuf3
      ]
      ++ nixlib.optional webui [
        pip
        addict
        future
        lmdb
        pyyaml
        scikitimage
        tqdm
        yapf
        gdown
        lpips
        lark
        analytics-python
        ffmpy
        markdown-it-py
        shap
        gradio
        fonts
        font-roboto
        piexif
        codeformer
        blip
        psutil
        openclip
        blendmodes
        imageio
        imageio-ffmpeg
        k-diffusion
        kornia
        protobuf
      ];
      overlay_default = nixpkgs: pythonPackages:
        {
          pytorch-lightning = pythonPackages.pytorch-lightning.overrideAttrs (old: {
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
      overlay_invoke = nixpkgs: pythonPackages:
        let
          ifNotMinVersion = pkg: ver: overlay: if (
            nixlib.versionOlder pkg.version ver
          ) then pkg.overrideAttrs overlay else pkg;
        in {
          protobuf = pythonPackages.protobuf3;
          huggingface-hub = ifNotMinVersion pythonPackages.huggingface-hub
            "0.13.2" (
          old: rec {
            version = "0.14.1";
            src = nixpkgs.fetchFromGitHub {
              owner = "huggingface";
              repo = "huggingface_hub";
              rev = "refs/tags/v${version}";
              hash = "sha256-+BtXi+O+Ef4p4b+8FJCrZFsxX22ZYOPXylexFtsldnA=";
            };
            propagatedBuildInputs = old.propagatedBuildInputs ++ [pythonPackages.fsspec];
          });
          transformers = ifNotMinVersion pythonPackages.transformers
            "4.26" (
          old: rec {
            version = "4.28.1";
              src = nixpkgs.fetchFromGitHub {
              inherit (old.src) owner repo;
              rev = "refs/tags/v${version}";
              hash = "sha256-FmiuWfoFZjZf1/GbE6PmSkeshWWh+6nDj2u2PMSeDk0=";
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
          mapCallPackage = pnames: builtins.listToAttrs (builtins.map (pname: { name = pname; value = (callPackage (./packages + "/${pname}") { }); }) pnames);
          simplePackages = [
            "filterpy"
            "kornia"
            "lpips"
            "ffmpy"
            "shap"
            "fonts"
            "font-roboto"
            "analytics-python"
            "markdown-it-py"
            "gradio"
            "hatch-requirements-txt"
            "timm"
            "blip"
            "fairscale"
            "torch-fidelity"
            "resize-right"
            "torchdiffeq"
            "accelerate"
            "clip-anytorch"
            "jsonmerge"
            "clean-fid"
            "getpass-asterisk"
            "pypatchmatch"
            "trampoline"
            "torchsde"
            "compel"
            "diffusers"
            "safetensors"
            "picklescan"
            "openclip"
            "blendmodes"
            "xformers"
            "pyre-extensions"
            # "triton" TODO: nixpkgs is missing required llvm parts - mlir. https://github.com/NixOS/nixpkgs/pull/163878
            "peft"
            "fastapi-events"
            "fastapi-socketio"
            "dynamicprompts"
            "easing-functions"
          ];
        in
        {
          pydeprecate = callPackage ./packages/pydeprecate { };
          taming-transformers-rom1504 =
            callPackage ./packages/taming-transformers-rom1504 { };
          albumentations = rmCallPackage ./packages/albumentations { opencv-python-headless = self.opencv4; };
          qudida = rmCallPackage ./packages/qudida { opencv-python-headless = self.opencv4; };
          gfpgan = rmCallPackage ./packages/gfpgan { opencv-python = self.opencv4; };
          basicsr = rmCallPackage ./packages/basicsr { opencv-python = self.opencv4; };
          facexlib = rmCallPackage ./packages/facexlib { opencv-python = self.opencv4; };
          codeformer = callPackage ./packages/codeformer { opencv-python = self.opencv4; };
          realesrgan = rmCallPackage ./packages/realesrgan { opencv-python = self.opencv4; };
          clipseg = rmCallPackage ./packages/clipseg { opencv-python = self.opencv4; };
          k-diffusion = callPackage ./packages/k-diffusion { clean-fid = self.clean-fid; };
          controlnet-aux = rmCallPackage ./packages/controlnet-aux { opencv-python = self.opencv4; };
          invisible-watermark = rmCallPackage ./packages/invisible-watermark { opencv-python = self.opencv4; };
          mediapipe = callPackage ./packages/mediapipe { opencv-contrib-python = self.opencv4; };
        } // mapCallPackage simplePackages;
      overlay_amd = nixpkgs: pythonPackages:
        rec {
          #IMPORTANT: you can browse available wheels on the server, but only if you add trailing "/" - e.g. https://download.pytorch.org/whl/rocm5.2/
          torch-bin = pythonPackages.torch-bin.overrideAttrs (old: {
            src = nixpkgs.fetchurl {
              name = "torch-1.13.1+rocm5.2-cp310-cp310-linux_x86_64.whl";
              url = "https://download.pytorch.org/whl/rocm5.2/torch-1.13.1%2Brocm5.2-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-82hdCKwNjJUcw2f5vUsskkxdRRdmnEdoB3SKvNlmE28=";
            };
          });
          torchvision-bin = pythonPackages.torchvision-bin.overrideAttrs (old: {
            src = nixpkgs.fetchurl {
              name = "torchvision-0.14.1+rocm5.2-cp310-cp310-linux_x86_64.whl";
              url = "https://download.pytorch.org/whl/rocm5.2/torchvision-0.14.1%2Brocm5.2-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-oBYG/K7bgkxu0UvmyS2U1ud2LkFQ/CarcxpEJ9xzMYQ=";
            };
          });
          torch = torch-bin;
          torchvision = torchvision-bin;
        };
      overlay_nvidia = nixpkgs: pythonPackages:
        {
          torch = pythonPackages.torch-bin;
          torchvision = pythonPackages.torchvision-bin;
        };
    in
    let
      nixpkgs_ = { amd ? false, nvidia ? false, webui ? false }:
        import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = nvidia; #CUDA is unfree.
          overlays = [
            (final: prev:
              let
                optional = nixlib.optionalAttrs;
                sl = (prev.streamlit.override ({ protobuf3 = prev.protobuf; }));
                makePythonHook = args: final.makeSetupHook ({ passthru.provides.setupHook = true; } // args);
                pythonRelaxDepsHook = prev.callPackage
                  ({ wheel }:
                    #upstream hook doesn't work properly with non-standard wheel names
                    #which means that some packages from pip silently fail to be overriden
                    #https://github.com/NixOS/nixpkgs/issues/198342
                    makePythonHook
                      {
                        name = "python-relax-deps-hook";
                        propagatedBuildInputs = [ wheel ];
                        substitutions = {
                          pythonInterpreter = nixlib.getExe prev.python3Packages.python;
                        };
                      } ./python-relax-deps-hook.sh)
                  { wheel = prev.python3.pkgs.wheel; };
              in
              {
                inherit pythonRelaxDepsHook;
                streamlit = sl.overrideAttrs (old: {
                  nativeBuildInputs = old.nativeBuildInputs ++ [ pythonRelaxDepsHook ];
                  pythonRemoveDeps = [ "protobuf" ];
                });
                python3 = prev.python3.override {
                  packageOverrides =
                    python-self: python-super:
                    (overlay_default prev python-super) //
                    optional amd (overlay_amd prev python-super) //
                    optional nvidia (overlay_nvidia prev python-super) //
                    optional webui (overlay_webui prev python-super) //
                    optional (!webui) (overlay_invoke prev python-super) //
                    (overlay_pynixify python-self);
                };
              })
          ];
        } // { inherit nvidia; };
    in
    {
      packages.${system} =
        let
          nixpkgsAmd = (nixpkgs_ { amd = true; });
          nixpkgsNvidia = (nixpkgs_ { nvidia = true; });
          invokeaiF = nixpkgs: nixpkgs.python3.pkgs.buildPythonApplication {
            pname = "invokeai";
            version = "3.0.2";
            src = invokeai-repo;
            format = "pyproject";
            meta.mainProgram = "invokeai";
            propagatedBuildInputs = requirementsFor { pkgs = nixpkgs; nvidia = nixpkgs.nvidia; };
            nativeBuildInputs = [ nixpkgs.pkgs.pythonRelaxDepsHook ];
            pythonRelaxDeps = [ "torch" "pytorch-lightning" "flask-socketio" "flask" "dnspython" "uvicorn" ];
            pythonRemoveDeps = [ "opencv-python" "flaskwebgui" "pyreadline3" ];
            postPatch = ''
              # Add subprocess to the imports
              substituteInPlace ./invokeai/backend/install/invokeai_configure.py --replace \
              'import shutil' \
'
import shutil
import subprocess
'
              # shutil.copytree will inherit the permissions of files in the /nix/store
              # which are read only, so we subprocess.call cp instead and tell it not to
              # preserve the mode
              substituteInPlace ./invokeai/backend/install/invokeai_configure.py --replace \
                "shutil.copytree(configs_src, configs_dest, dirs_exist_ok=True)" \
                "subprocess.call(f'cp -r --no-preserve=mode {configs_src}/* {configs_dest}', shell=True)"
            '';
          };
          webuiF = nixpkgs: 
          let
            submodel = pkg: nixpkgs.pkgs.python3.pkgs.${pkg} + "/lib/python3.10/site-packages";
            taming-transformers = submodel "taming-transformers-rom1504";
            k_diffusion = submodel "k-diffusion";
            codeformer = (submodel "codeformer") + "/codeformer";
            blip = (submodel "blip") + "/blip";
          in
          nixpkgs.python3.pkgs.buildPythonApplication {
            pname = "stable-diffusion-webui";
            version = "2023-03-12";
            src = webui-repo;
            format = "other";
            propagatedBuildInputs = requirementsFor { pkgs = nixpkgs; webui = true; nvidia = nixpkgs.nvidia; };
            nativeBuildInputs = [ nixpkgs.pkgs.makeWrapper ];
            meta.mainProgram = "flake-launch";
            buildPhase = ''
                  runHook preBuild
                  cp -r . $out
                  chmod -R +w $out
                  cd $out

                  #firstly, we need to make launch.py runnable by adding python shebang
                  cat <<-EOF > exec_launch.py.unwrapped
                  $(echo "#!/usr/bin/python") 
                  $(cat launch.py) 
                  EOF
                  chmod +x exec_launch.py.unwrapped

                  #creating wrapper around launch.py with PYTHONPATH correctly set
                  makeWrapper "$(pwd)/exec_launch.py.unwrapped" exec_launch.py \
                    --set-default PYTHONPATH $PYTHONPATH

                  mkdir $out/bin
                  pushd $out/bin
                  ln -s ../exec_launch.py launch.py
                  buck='$' #escaping $ inside shell inside shell is tricky
                  #next is an additional shell wrapper, which sets sensible default args for CLI
                  #additional arguments will be passed further
                  cat <<-EOF > flake-launch
                  #!/usr/bin/env bash 
                  pushd $out        #For some reason, fastapi only works when current workdir is set inside the repo
                  trap "popd" EXIT

                  "$out/bin/launch.py" --skip-install "$buck{@}"
                  EOF
                    # below lie remnants of my attempt to make webui use similar paths as InvokeAI for models download
                    # additions of such options in upstream is a welcome sign, however they're mostly ignored and therefore useless
                    # TODO: check in 6 months, maybe it'll work
                    # For now, your best bet is to use ZFS dataset with dedup enabled or make symlinks after the fact
                    
                    #--codeformer-models-path "\$mp/codeformer" \
                    #--gfpgan-models-path "\$mp/gfpgan" --esrgan-models-path "\$mp/esrgan" \
                    #--bsrgan-models-path "\$mp/bsrgan" --realesrgan-models-path "\$mp/realesrgan" \
                    #--clip-models-path "\$mp/clip" 
                  chmod +x flake-launch
                  popd

                  runHook postBuild
            '';
            installPhase = ''
                  runHook preInstall

                  rm -rf repositories/
                  mkdir repositories
                  pushd repositories
                  ln -s ${inputs.stable-diffusion-repo}/ stable-diffusion-stability-ai
                  ln -s ${taming-transformers}/ taming-transformers
                  ln -s ${k_diffusion}/ k-diffusion
                  ln -s ${codeformer}/ CodeFormer
                  ln -s ${blip}/ BLIP
                  popd
                  runHook postInstall
            '';
          };
        in
        {
          invokeai = {
            amd = invokeaiF nixpkgsAmd;
            default = invokeaiF nixpkgsNvidia;
          };
          webui = {
            amd = webuiF nixpkgsAmd;
            default = webuiF nixpkgsNvidia;
          };
        };
    };
}
