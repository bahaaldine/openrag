import yaml
import sys

def get_project_name(yaml_file):
    with open(yaml_file, 'r') as file:
        data = yaml.safe_load(file)
        return data['metadata']['name']

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: get_project_name.py <yaml-file>")
        sys.exit(1)

    print(get_project_name(sys.argv[1]))
