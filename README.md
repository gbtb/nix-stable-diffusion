# Table of contents
- [nix-stable-diffusion](#nix-stable-diffusion)
  - [What's done](#whats-done)
- [How to use it?](#how-to-use-it)
  - [InvokeAI](#invokeai)
  - [stable-diffusion-webui aka 111AUTOMATIC111 fork](#stable-diffusion-webui-aka-111automatic111-fork)
- [What's needed to be done](#whats-needed-to-be-done)
- [Updates and versioning](#updates-and-versioning)
- [Acknowledgements](#acknowledgements)

# nix-stable-diffusion
Flake for running SD on NixOS

## What's done
* Nix devShell capable of running InvokeAI's and stable-diffusion-webui flavors of SD without need to reach for pip or conda (including AMD ROCM support)
* ...???
* PROFIT

# How to use it?
## InvokeAI
1. Clone repo
1. Run `nix run -L .#invokeai.{default,amd,nvidia} -- --web`, wait for package to build
    1. `.#invokeai.default` builds package which overrides bare minimum required for SD to run
    1. `.#invokeai.amd` builds package which overrides torch packages with ROCM-enabled bin versions
    1. `.#invokeai.nvidia` builds package with overlay explicitly setting `cudaSupport = true` for torch
1. Weights download 
    1. **Built-in CLI way.** Upon first launch InvokeAI will check its default config dir (~/invokeai) and suggest you to run build-in TUI startup configuration script that help you to download default models or supply existing ones to InvokeAI. Follow the instructions and finish configuration. Note: you can also pass option `--root_dir` to pick another location for configs/models installation. More fine-grained directory setup options also available - run `nix run .#invokeai -- --help` for more info.
    2. **Build-in GUI way.** Recent version of InvokeAI added GUI for model managing. See upstream [docs](https://invoke-ai.github.io/InvokeAI/installation/050_INSTALLING_MODELS/#installation-via-the-webui) on that matter.
1. CLI arguments for invokeai itself can be supplied after `--` part of the nix run command
1. If you need to run additional scripts (like invokeai-merge, invokeai-ti), then you can run `nix build .#invokeai` and call those scripts manually like that: `./result/bin/invokeai-ti`.

## stable-diffusion-webui aka 111AUTOMATIC111 fork
1. Clone repo
1. Clone submodule with stable-diffusion-webui
1. Run `nix develop .#webui.{default,nvidia,amd}`, wait for shell to build
    1. `.#webui.default` builds shell which overrides bare minimum required for SD to run
    1. `.#webui.amd` builds shell which overrides torch packages with ROCM-enabled bin versions
    1. `.#webui.nvidia` builds shell with overlay explicitly setting `cudaSupport = true` for torch
1. Obtain and place SD weights into `stable-diffusion-webui/models/Stable-diffusion/model.ckpt`
1. Inside `stable-diffusion-webui/` directory, run `python launch.py` to start web server. It should preload required models from the start. Additional models, such as CLIP, will be loaded before the first actual usage of them.

## ROCM shenanigans
todo

# What's needed to be done

- [x] devShell with CUDA support (should be trivial, but requires volunteer with NVidia GPU) 
- [ ] Missing packages definitions should be submitted to Nixpkgs
- [x] Investigate ROCM device warning on startup
- [x] Apply patches so that all downloaded models would go into one specific folder
- [ ] Should create a PR to pynixify with "skip-errors mode" so that no ugly patches would be necessary
- [ ] Shell hooks for initial setup?
- [x] May be this devShell should be itself turned into a package?
- [x] Add additional flavors of SD ?

# Updates and versioning

Current versions:
- InvokeAI 2.3.1.post2
- stable-diffusion-webui 27.10.2022

I have no intention to keep up with development pace of these apps, especially the Automatic's fork :) . However, I will ocasionally update at least InvokeAI's flake. Considering versioning, I will try to follow semver with respect to submodules as well, which means major version bump for submodule = major version bump for this flake. 

# Acknowledgements

Many many thanks to https://github.com/cript0nauta/pynixify which generated all the boilerplate for missing python packages.  
Also thanks to https://github.com/colemickens/stable-diffusion-flake and https://github.com/skogsbrus/stable-diffusion-nix-flake for inspiration and some useful code snippets.

# Similar projects
todo
