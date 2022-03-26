# Python Virtual Environment Terminal Extension

An extension to the Linux terminal to easily manage python virtual environments.

## Installation

1. Download repository
2. Open repository in terminal
3. Run: `./install.sh`

Or copy and run:

```bash
git clone https://gitlab.com/richard-nagy/python-virtual-environment-terminal-extension &&
cd python-virtual-environment-terminal-extension &&
./install.sh &&
cd .. &&
rm -r python-virtual-environment-terminal-extension
```

## Manual Installation

1. Copy `.env` and `venv.sh` to `~/.venvconfig/` folder.
2. To auto run script on bash start, add the following line to `~/.bashrc`

```bash
source ~/.venvconfig/venv.sh
```

> **Why does it have to be installed like this?**
> This script adds new functions to your terminal, so it has to run when your bash runs.

## Usage

|Command|Effect|
|---|---|
|`venv`|Displays help listing all commands.|
|`venv load`|Creates and activates a virtual environment, then installs packages.|
|`venv exit`|Deactivate current virtual environment.|
|`venv lock`|Save currently installed packages to lock file.|
|`venv install`|Install packages from requirements file.|
|`venv install lock`|Install packages from lock file.|
|`venv activate`|Activate virtual environment in current directory (recommended to use load).|
|`venv add [name]`|Install and add package to requirements and lock.|