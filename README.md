# Python Virtual Environment Terminal Extension

An extension to the Linux terminal to easily manage python virtual environments.

## Installation

1. Download repository
2. Open repository in terminal
3. Run: `./install.sh`

Or copy and run:

```bash
git clone https://gitlab.com/richardnagy/python-venv-terminal-extension &&
cd python-virtual-environment-terminal-extension &&
./install.sh &&
cd .. &&
rm -r python-virtual-environment-terminal-extension
```

> ⚠️ You need to restart your terminal for the script to load. You can just type `bash`.

## Manual Installation

1. Copy `.env` and `venv.sh` to `~/.venvconfig/` folder.
2. To auto run script on bash start, add the following line to `~/.bashrc`

```bash
source ~/.venvconfig/venv.sh
```

> ❔ **Why does it have to be installed like this?**
>
> This script adds new functions to your terminal by modifying the currently running instance.
> Actvating a virtual environment works the same way, so it has to be loaded every time.
> Adding it to bashrc file will automate the loading of the script.

## Usage

|Command|Effect|
|---|---|
|`venv`, `venv help`|Displays help listing all commands.|
|`venv load`|Creates and activates a virtual environment, then installs packages.|
|`venv exit`|Deactivate current virtual environment.|
|`venv lock`|Save currently installed packages to lock file.|
|`venv install`|Install packages from requirements file.|
|`venv install lock`|Install packages from lock file.|
|`venv activate`|Activate virtual environment in current directory (recommended to use load).|
|`venv add [name]`|Install and add package to requirements and lock.|
|`venv run`|Runs current package main python file.|
