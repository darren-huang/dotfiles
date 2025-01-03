# shared between my bash and zsh configurations

# create function 'myenv' to set up a Python virtual environment
myenv() {
    case "$1" in
        setup-pip)
            myenv_setup-pip
            ;;
        update-reqs)
            myenv_update-reqs
            ;;
        py-ver)
            shift
            myenv_py-ver "$@"
            ;;
        create)
            myenv_create
            ;;
        *)
            echo "Usage: myenv {setup-pip|update-reqs|py-ver|create}"
            return 1
            ;;
    esac
}

myenv_setup-pip() {
    python -m pip install --upgrade pip pip-tools
}

myenv_update-reqs() {
    if [ ! -f "requirements.in" ]; then
        echo "requirements.in not found"
        return 1
    fi

    myenv setup-pip
    python -m piptools compile requirements.in
    python -m pip install -r requirements.txt
}

myenv_py-ver() {
    if [ -z "$1" ]; then
        echo "Usage: myenv py-ver <python_version>"
        return 1
    fi

    if [[ ! "$1" =~ ^(2|3)\.[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Invalid Python version format. Please use a valid version (e.g., 2.7, 3.8, 3.9.1)."
        return 1
    fi

    pyenv local "$1"
}

myenv_create() {
    if [ ! -f ".python-version" ]; then
        echo ".python-version file not found. Please set the Python version using 'myenv py-ver <python_version>'."
        return 1
    fi

    python_version=$(cat .python-version)

    if pyenv versions | grep -q "$python_version"; then
        pyenv local "$python_version"
        if [ -f "requirements.in" ]; then
            python -m venv venv
            source venv/bin/activate
            myenv_setup-pip
            myenv_update-reqs
        else
            echo "requirements.in not found"
        fi
    else
        echo "Python version $python_version is not installed. Please install it using 'pyenv install x.x' first."
    fi
}
