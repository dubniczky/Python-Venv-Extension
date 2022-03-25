#!/bin/bash

# Load environment variables
#export $(cat .env | xargs)
source .env

# Colored echo
venv.echoc()
{
    RED="\033[0;31m"
    GREEN="\033[0;32m"
    YELLOW="\033[1;33m"
    
    NONE="\033[0m" # No color

    printf "${!1}${2}${NONE}"
}

# Colored echo with new line
venv.echocl()
{
    venv.echoc "$1" "$2\n"
}

# Load virtual environment script
venv.load()
{
    # [1/5] Create virtual environment
    venv.echoc "GREEN" "[1/5] "
    echo "Creating virtual environment... ($VENV_NAME/)"
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
        venv.echocl "RED" "Error: Python is not installed."
        exit 1
    fi


    # [2/5] Activate environment
    venv.echoc "GREEN" "[2/5] "
    echo "Activating environment..."
    source $VENV_NAME/bin/activate


    # [3/5] Install packages
    venv.echoc "GREEN" "[3/5] "
    echo "Installing packages... (/$VENV_DEPS_NAME)"
    # Check pip installation
    if pip --version > /dev/null; then
        echo "Found pip"
        if [ "$VENV_PRIORITIZE_LOCK" = "true" ] && test -f "$VENV_LOCK_NAME"; then
            echo "Installing dependencies from lock file..."
            pip install -r $VENV_LOCK_NAME
        else
            echo "Installing dependencies from requirements file..."
            pip install -r $VENV_DEPS_NAME
        fi
    else
        venv.echocl "RED" "Error: Pip is not installed."
        exit 2
    fi
    

    # [4/5] Save used package versions
    venv.echoc "GREEN" "[4/5] "
    echo "Creating lock file... (/$VENV_LOCK_NAME)"
    venv.lock


    # [5/5] Save used package versions
    venv.echoc "GREEN" "[5/5] "
    echo "Virtual environment ready. ($VENV_NAME/)"
}

# Install dependencies
venv.install()
{
    if [ "$1" = "lock" ]; then
        pip install -r $VENV_LOCK_NAME
    else
        pip install -r $VENV_DEPS_NAME
    fi
}

# Create dependency lock file
venv.lock()
{
    if [[ -v VIRTUAL_ENV ]]; then
        pip freeze > $VENV_LOCK_NAME
        echo "Lock file created: $VENV_LOCK_NAME"
    else
        venv.echocl "RED" "Error: Virtual environment is not activated."
        exit 1
    fi
}

# Activate current virtual environment
venv.activate()
{
    if [ -f "$VENV_NAME/bin/activate" ]; then
        source $VENV_NAME/bin/activate
    else
        venv.echocl "RED" "Error: Could not find virtual environment.";
        return 1;
    fi
}

# Main venv command
venv()
{
    if [ "$1" = "load" ]; then
        venv.load;
    elif [ "$1" = "exit" ]; then
        deactivate;
    elif [ "$1" = "install" ]; then
        venv.install $2;
    elif [ "$1" = "lock" ]; then
        venv.lock;
    elif [ "$1" = "activate" ]; then
        venv.activate;
    else
        venv.load;
    fi
}