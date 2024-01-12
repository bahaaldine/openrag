#!/bin/bash


# Define the Python virtual environment directory
VENV_DIR="venv_openrag"

# Function to setup Python virtual environment and install dependencies
setup_python_env() {
    echo "Setting up Python environment..."

    # Check if virtual environment directory exists
    if [ ! -d "$VENV_DIR" ]; then
        # Create a virtual environment
        python3 -m venv "$VENV_DIR"
    fi

    # Activate the virtual environment
    source "$VENV_DIR/bin/activate"

    # Install required Python packages
    pip install pyyaml jsonschema

    echo "Python environment setup complete."
}

# Function to display the help manual
show_help() {
    echo "Usage: openrag <command> [options]"
    echo "Commands:"
    echo "  make <yaml-file>     Validate a YAML file against the OpenRAG schema"
    echo "  clean <yaml-file>    Clean up the project directory"
    echo "  create -name <name>  Create a new project with the specified name"
    # Add other commands and their descriptions here
}
# Function to validate YAML file against the schema
validate_yaml() {
    python validator/validate.py "$1"
}

# Function to create a new project
create_project() {
    if [ "$#" -lt 2 ]; then
        echo "Project name is required. Use -name <name>."
        exit 1
    fi

    if [[ "$1" != "-name" ]]; then
        echo "Invalid option: $1. Use -name <name>."
        exit 1
    fi

    local project_name="$2"

    # Setup Python environment and install dependencies
    setup_python_env

    # Logic to create the project directory and initial files
    echo "Creating project '$project_name'..."
    mkdir -p "$project_name"

    touch "$project_name/config.yaml"  # Placeholder for initial project file
    echo "Project '$project_name' created."

    # Call Python script to generate YAML with defaults
    python generator/generate_yaml.py schema/openrag-schema.json "$project_name" "$project_name"
}

# Function to clean the project directory
clean_project() {
    project_name=$(python validator/get_project_name.py "$1")
    echo "You are about to clean the project: $project_name."
    echo "This will remove all files in the folder named after the project."
    echo "Please type the name of the project to confirm:"

    read user_confirmation

    if [ "$user_confirmation" = "$project_name" ]; then
        echo "Cleaning the project..."
        rm -rf "./$project_name"
        echo "Clean completed."
    else
        echo "Project name does not match. Clean aborted."
    fi
}

# Check the command
case "$1" in
    create)
        shift  # Remove 'create' from the arguments list
        create_project "$@"
        ;;
    clean)
        if [ "$#" -ne 2 ]; then
            echo "Usage: openrag clean <yaml-file>"
            exit 1
        fi
        clean_project "$2"
        ;;
    *)
        echo "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
