#!/bin/bash

venv.load()
{
    # Create venv
    echo "[1/5] Creating virtual environment... ($VENV_NAME)"
    python -m venv "$VENV_NAME"

    # Activate environment
    echo "[2/5] Activating environment..."
    source $VENV_NAME/bin/activate

    # Install packages
    echo "[3/5] Installing packages..."
    echo "${pwd}/$VENV_DEPS_NAME"
    pip install -r $VENV_DEPS_NAME

    # Save used package versions
    echo "[4/5] Creating lock file..."
    echo "${pwd}/$VENV_LOCK_NAME"
    pip freeze > $VENV_LOCK_NAME

    echo "[5/5] Virtual environment ready."
    echo "${pwd}/$VENV_NAME"
}

venv()
{
    if test "$1" = "load"
    then
        venv.load;
    elif test "$1" = "exit"
    then
        deactivate;
    else
        echo "Unknown command. Use load or exit"
    fi
}