#!/bin/bash

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


# Load environment variables
# If file does not exist, we assume it's already loaded.
export VENV_CONFIG="~/.venvconfig/.env"
if [ -f "$VENV_CONFIG" ]; then
    #source "$VENV_CONFIG"
    export $(cat $VENV_CONFIG | grep -v '^#\|^$' | xargs)
elif [ -f ".env" ]; then
    #source .env
    export $(cat .env | grep -v '^#\|^$' | xargs)
fi


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
        return 1
    fi


    # [2/5] Activate environment
    venv.echoc "GREEN" "[2/5] "
    echo "Activating environment..."
    venv.activate;


    # [3/5] Install packages
    venv.echoc "GREEN" "[3/5] "
    echo "Installing packages... (/$VENV_DEPS_NAME)"
    # Check pip installation
    if pip --version > /dev/null; then
        echo "Found pip"
        if [ "$VENV_PRIORITIZE_LOCK" = "true" ] && [ -f "$VENV_LOCK_NAME" ] && [ -s "$VENV_LOCK_NAME" ]; then
            # lock is prioritized, lock exists, lock is not empty
            echo "Installing dependencies from lock file..."
            pip install -r $VENV_LOCK_NAME
        else
            if [ -f "$VENV_DEPS_NAME" ]; then
                echo "Installing dependencies from requirements file..."
                pip install -r $VENV_DEPS_NAME
            else
                venv.echocl "YELLOW" "No requirements file found, skipping install."
                echo "Created requirements file: $VENV_DEPS_NAME"
                touch "$VENV_DEPS_NAME"
            fi
        fi
    else
        venv.echocl "RED" "Error: Pip is not installed."
        return 1
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
        if [ -f "$VENV_LOCK_NAME" ]; then
            pip install -r $VENV_LOCK_NAME
        else
            venv.echocl "RED" "Error: No lock file found ($VENV_LOCK_NAME)"
            return 1
        fi
    else
        if [ -f "$VENV_DEPS_NAME" ]; then
            pip install -r $VENV_DEPS_NAME
        else
            venv.echocl "RED" "Error: No requirements file found ($VENV_DEPS_NAME)"
            return 1
        fi
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
        return 1
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

# Add a package to dependiencies
venv.add()
{
    # Check if inside virtual environment
    if ! [[ -v VIRTUAL_ENV ]]; then
        echo "Not in virtual environment."
        return 1
    fi

    # Check if package name is not empty
    if [ -z $1 ]; then
        echo "Please specify a package name."
        return 1
    fi

    # Check if already added as dependency
    if grep -q ^$1$ "$VENV_DEPS_NAME"; then
        echo "Package already added as dependency."
        return 1
    fi

    # Try to install using pip
    pip install "$1"
    if [ $? != 0 ]; then
        echo "Could not find package, not added to requirements: '$1'"
        return 1
    fi

    # Add to dependencies
    if [[ -s "$VENV_DEPS_NAME" && -z "$(tail -c 1 "$VENV_DEPS_NAME")" ]]; then
        # If last line is empty
        echo "$1" >> "$VENV_DEPS_NAME"
    else
        # If last line is not empty
        echo "" >> "$VENV_DEPS_NAME"
        echo "$1" >> "$VENV_DEPS_NAME"
    fi
    echo "Added to requirements file: $VENV_DEPS_NAME"
    
    # Update lock file
    pip freeze > $VENV_LOCK_NAME
    echo "Updated lock file: $VENV_LOCK_NAME"

    return 0
}

venv.help()
{
    echo "   help - Displays help listing all commands."
    echo "   load - Creates and activates a virtual environment, then installs packages."
    echo "   exit - Deactivate current virtual environment."
    echo "   lock - Save currently installed packages to lock file."
    echo "   install - Install packages from requirements file."
    echo "   install lock - Install packages from lock file."
    echo "   activate - Activate virtual environment in current directory (recommended to use load)."
    echo "   add [name] - Install and add package to requirements and lock."
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
    elif [ "$1" = "add" ]; then
        venv.add $2;
    elif [ "$1" = "help" ]; then
        venv.help;
    else
        venv.help;
    fi
}