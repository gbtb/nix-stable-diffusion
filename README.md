# Table of contents
- [nix-stable-diffusion](#nix-stable-diffusion)
  * [What's done](#whats-done)
- [How to use it?](#how-to-use-it)
  * [InvokeAI](#invokeai)
  * [stable-diffusion-webui aka 111AUTOMATIC111 fork](#stable-diffusion-webui-aka-111automatic111-fork)
  * [Hardware quirks](#hardware-quirks)
    + [AMD](#amd)
    + [Nvidia](#nvidia)
- [What's (probably) needed to be done](#whats-probably-needed-to-be-done)
- [Current versions](#current-versions)
- [Meta](#meta)
  * [Contributions](#contributions)
  * [Acknowledgements](#acknowledgements)
  * [Similar projects](#similar-projects)

# nix-stable-diffusion
Flake for running SD on NixOS

## What's done
* Nix flake capable of running InvokeAI's and stable-diffusion-webui flavors of SD without need to reach for pip or conda (including AMD ROCM support)
* ...???
* PROFIT

# How to use it?
## InvokeAI
1. Clone repo
1. Run `nix run .#invokeai.{default,amd} -- --web --root_dir "folder for configs and models"`, wait for package to build
    1. `.#invokeai.default` builds package with default torch-bin that has CUDA-support by default
    1. `.#invokeai.amd` builds package which overrides torch packages with ROCM-enabled bin versions
1. Weights download 
    1. **Built-in CLI way.** Upon first launch InvokeAI will check its default config dir (~/invokeai) and suggest you to run build-in TUI startup configuration script that help you to download default models or supply existing ones to InvokeAI. Follow the instructions and finish configuration. Note: you can also pass option `--root_dir` to pick another location for configs/models installation. More fine-grained directory setup options also available - run `nix run .#invokeai.amd -- --help` for more info.
    2. **Build-in GUI way.** Recent version of InvokeAI added GUI for model managing. See upstream [docs](https://invoke-ai.github.io/InvokeAI/installation/050_INSTALLING_MODELS/#installation-via-the-webui) on that matter.
1. CLI arguments for invokeai itself can be supplied after `--` part of the nix run command
1. If you need to run additional scripts (like invokeai-merge, invokeai-ti), then you can run `nix build .#invokeai.amd` and call those scripts manually like that: `./result/bin/invokeai-ti`.

## stable-diffusion-webui aka 111AUTOMATIC111 fork
1. Clone repo
1. Run `nix run .#webui.{default,amd} -- --data-dir "runtime folder for webui stuff" --ckpt-dir "folder with pre-downloaded main SD models"`, wait for packages to build
    1. `.#webui.default` builds package with default torch-bin that has CUDA-support by default
    1. `.#webui.amd` builds package which overrides torch packages with ROCM-enabled bin versions
1. Webui is not a proper python package by itself, so I had to make a multi-layered wrapper script which sets required env and args. `bin/flake-launch` is a top-level wrapper, which sets default args and is running by default. `bin/launch.py` is a thin wrapper around original launch.py which only sets PYTHONPATH with required packages. Both wrappers pass additional args further down the pipeline. To list all available args you may run `nix run .#webui.amd -- --help`.

## Hardware quirks
### AMD
If you get an error `"hipErrorNoBinaryForGpu: Unable to find code object for all current devices!"`, then probably your GPU is not fully supported by ROCM (only several gpus are by default) and you have to set env variable to trick ROCM into running - `export HSA_OVERRIDE_GFX_VERSION=10.3.0`

### Nvidia
* **Please note, that I don't have an nvidia gpu and therefore I can't test that CUDA functionality actually work. If something is broken in that department, please open an issue, or even better - submit a PR with a proposed fix.**
* xformers for CUDA hasn't been tested. Python package added to the flake, but it's missing triton compiler. It might partially work, so please test it and report back :)

# What's (probably) needed to be done

- [ ] Most popular missing packages definitions should be submitted to Nixpkgs
- [ ] Try to make webui to use same paths and filenames for weights, as InvokeAI (through patching/args/symlinks)
- [ ] Should create a PR to pynixify with "skip-errors mode" so that no ugly patches would be necessary
- [ ] Increase reproducibility by replacing models, downloaded in runtime, to proper flake inputs

# Current versions

- InvokeAI 2.3.5.post2
- stable-diffusion-webui 12.03.2023

# Meta

## Contributions
Contributions are welcome. I have no intention to keep up with development pace of these apps, especially the Automatic's fork :) . 
However, I will ocasionally update at least InvokeAI's flake. Considering versioning, I will try to follow semver with respect to submodules as well, which means major version bump for submodule = major version bump for this flake. 
## Acknowledgements
Many many thanks to https://github.com/cript0nauta/pynixify which generated all the boilerplate for missing python packages.  
Also thanks to https://github.com/colemickens/stable-diffusion-flake and https://github.com/skogsbrus/stable-diffusion-nix-flake for inspiration and some useful code snippets.

## Similar projects
You may want to check out [Nixified-AI](https://github.com/nixified-ai/flake). It aims to support broader range (e.g. text models) of AI models in NixOS.
