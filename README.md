# nix-stable-diffusion
Flake for running SD on NixOS

## What's done
* Nix devShell capable of running InvokeAI's and stable-diffusion-webui flavors of SD without need to reach for pip or conda (including AMD ROCM support)
* ...???
* PROFIT

# How to use it?
## InvokeAI
1. Clone repo
1. Clone submodule with InvokeAI
1. Run `nix develop .#invokeai.{default,nvidia,amd}`, wait for shell to build
    1. `.#invokeai.default` builds shell which overrides bare minimum required for SD to run
    1. `.#invokeai.amd` builds shell which overrides torch packages with ROCM-enabled bin versions
    1. `.#invokeai.nvidia` builds shell with overlay explicitly setting `cudaSupport = true` for torch
1. Inside InvokeAI's directory, run `python scripts/preload_models.py` to preload models (doesn't include SD weights)
1. Obtain and place SD weights into `models/ldm/stable-diffusion-v1/model.ckpt`
1. Run CLI with `python scripts/invoke.py` or GUI with `python scripts/invoke.py --web`
1. For more detailed instructions consult https://invoke-ai.github.io/InvokeAI/installation/INSTALL_LINUX/

## stable-diffusion-webui aka 111AUTOMATIC111 fork
1. Clone repo
1. Clone submodule with stable-diffusion-webui
1. Run `nix develop .#webui.{default,nvidia,amd}`, wait for shell to build
    1. `.#webui.default` builds shell which overrides bare minimum required for SD to run
    1. `.#webui.amd` builds shell which overrides torch packages with ROCM-enabled bin versions
    1. `.#webui.nvidia` builds shell with overlay explicitly setting `cudaSupport = true` for torch
1. Obtain and place SD weights into `stable-diffusion-webui/models/Stable-diffusion/model.ckpt`
1. Inside `stable-diffusion-webui/` directory, run `python launch.py` to start web server. It should preload required models from the start. Additional models, such as CLIP, will be loaded before the first actual usage of them.

## What's needed to be done

- [x] devShell with CUDA support (should be trivial, but requires volunteer with NVidia GPU) 
- [ ] Missing packages definitions should be submitted to Nixpkgs
- [x] Investigate ROCM device warning on startup
- [ ] Apply patches so that all downloaded models would go into one specific folder
- [ ] Should create a PR to pynixify with "skip-errors mode" so that no ugly patches would be necessary
- [ ] Shell hooks for initial setup?
- [ ] May be this devShell should be itself turned into a package?
- [x] Add additional flavors of SD ?

## Updates and versioning

Current versions:
- InvokeAI 2.0.2
- stable-diffusion-webui 27.10.2022

I have no intention to keep up with development pace of these apps, especially the automatic's fork :) . However, I will ocasionally update at least InvokeAI flake. Considering versioning, I will try to follow semver with respect to submodules as well, which means major releases for submodule = major release for this flake. 

## Acknowledgements

Many many thanks to https://github.com/cript0nauta/pynixify which generated all the boilerplate for missing python packages.  
Also thanks to https://github.com/colemickens/stable-diffusion-flake and https://github.com/skogsbrus/stable-diffusion-nix-flake for inspiration and some useful code snippets.
