# nix-stable-diffusion
Flake for running SD on NixOS

## What's done
* Nix devShell capable of running InvokeAI's flavor of SD without need to fallback for pip or conda (including AMD ROCM support)
* ...???
* PROFIT

# How to use it?
1. Clone repo
1. Clone submodule with InvokeAI
1. Run `nix develop .#invokeai.{default,nvidia,amd}`, wait for shell to build
    1. `.#invokeai.default` builds shell which overrides bare minimum required for SD to run
    1. `.#invokeai.amd` builds shell which overrides torch packages with ROCM-enabled bin versions
    1. `.#invokeai.nvidia` builds shell with overlay explicitly setting `cudaSupport = true` for torch
1. Inside InvokeAI's directory, run `python scripts/preload_models.py` to preload models
1. Place SD weights into `models/ldm/stable-diffusion-v1/model.ckpt`
1. Run CLI with `python scripts/invoke.py` or GUI with `python scripts/invoke.py --web`
1. For more detailed instructions consult https://invoke-ai.github.io/InvokeAI/installation/INSTALL_LINUX/

## What's needed to be done

- [x] devShell with CUDA support (should be trivial, but requires volunteer with NVidia GPU) 
- [ ] Missing packages definitions should be submitted to Nixpkgs
- [ ] Investigate ROCM device warning on startup
- [ ] Apply patches so that all downloaded models would go into one specific folder
- [ ] Should create a PR to pynixify with "skip-errors mode" so that no ugly patches would be necessary
- [ ] Shell hooks for initial setup?
- [ ] May be this devShell should be itself turned into a package?
- [ ] Add additional flavors of SD ?

## Acknowledgements

Many many thanks to https://github.com/cript0nauta/pynixify which generated all the boilerplate for missing python packages.  
Also thanks to https://github.com/colemickens/stable-diffusion-flake and https://github.com/skogsbrus/stable-diffusion-nix-flake for inspiration and some useful code snippets.
