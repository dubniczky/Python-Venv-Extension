# Python Virtual Environment Terminal Extension

An extension to the Linux terminal to easily manage python virtual environments.

## Installation

1. Download repository
2. Open repository in terminal
3. Run: `./install.sh`

## Manual Installation

1. Copy `.env` and `venv.sh` to `~/.venvconfig/` folder.
2. To auto run script on bash start, add the following line to `~/.bashrc`

```bash
source ~/.venvconfig/venv.sh
```

> **Why does it have to be installed like this?**
> This script adds new functions to your terminal, so it has to run when your bash runs.

## Usage

- Load venv: `venv` or `venv load`
- Exit venv: `venv exit`