# Love2d Playground

This is a playground displaying various 2D scenes, powered by the [LÖVE](https://love2d.org/) framework for Lua.

## Setup

This project uses Git submodules, so make sure you clone it properly.

### Clone the repository (with submodules)

```bash
git clone --recurse-submodules https://github.com/ErkoBerko/Love2d-Playground.git
```

### If you already cloned without submodules

Run the following commands inside the repository:

```bash
git submodule init
git submodule update
```

### Keeping submodules up to date

To pull the latest changes including submodules:

```bash
git pull --recurse-submodules
git submodule update --init --recursive
```

### Installing LÖVE

Install LÖVE by following the instructions here https://love2d.org/wiki/Getting_Started

## Application Usage

### Scene Selection

use the numbers keys to select a scene to view

### Hot-reloading

press `r` to reload the Lua code while the program is running

## Future Updates
- **Resilient hot-reloading** – allow Lua code to be hot-reloaded even after a runtime error has occurred.
- Resolution-independent rendering
