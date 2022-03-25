#!/bin/bash

# Load environment variables
export $(cat .env | xargs)

# Load virtual environment script
venv.load()
{
    # [1/5] Create virtual environment
    echo "[1/5] Creating virtual environment... ($VENV_NAME/)"
    # Check python installation with multiple commands
    if python --version > /dev/null; then # python
        echo "Python found with command: \"python\""
        version=`python --version | cut -c 8-`
        echo "Using version: $version"
        python -m venv "$VENV_NAME"
    elif python3 --version > /dev/null; then # python3
        echo "Python found with command: \"python3\""
        version=`python3 --version | cut -c 8-`
        echo "Using version: $version"
        python3 -m venv "$VENV_NAME"
    elif py --version > /dev/null; then # py
        echo "Python found with command: \"py\""
        version=`py --version | cut -c 8-`
        echo "Using version: $version"
        py -m venv "$VENV_NAME"
    else
        echo "Error: Python is not installed."
        exit 1
    fi

    # [2/5] Activate environment
    echo "[2/5] Activating environment..."
    source $VENV_NAME/bin/activate

    # [3/5] Install packages
    echo "[3/5] Installing packages... (/$VENV_DEPS_NAME)"
    # Check pip installation
    if pip --version > /dev/null; then
        if [ "$VENV_PRIORITIZE_LOCK" = "true" ] && test -f "$VENV_LOCK_NAME"; then
            echo "Installing dependencies from lock file..."
            pip install -r $VENV_LOCK_NAME
        else
            echo "Installing dependencies from requirements file..."
            pip install -r $VENV_DEPS_NAME
        fi
    else
        echo "Error: Pip is not installed."
        exit 2
    fi
    

    # [4/5] Save used package versions
    echo "[4/5] Creating lock file..."
    echo "${pwd}/$VENV_LOCK_NAME"
    pip freeze > $VENV_LOCK_NAME

    # [5/5] Save used package versions
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