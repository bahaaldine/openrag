import json
import yaml
import sys
import os

def load_json_schema(schema_filename):
    with open(schema_filename, 'r') as file:
        return json.load(file)

def extract_defaults(json_schema):
    defaults = {}
    if "properties" in json_schema:
        for key, value in json_schema["properties"].items():
            if "default" in value:
                defaults[key] = value["default"]
            elif "properties" in value:
                defaults[key] = extract_defaults(value)
    return defaults

def generate_yaml_with_defaults(schema_file, output_dir, project_name):
    json_schema = load_json_schema(schema_file)
    defaults = extract_defaults(json_schema)

    output_file = os.path.join(output_dir, f"{project_name}/config.yaml")
    with open(output_file, 'w') as file:
        yaml.dump(defaults, file, default_flow_style=False)

    print(f"YAML file generated with defaults at {output_file}")

def main():
    if len(sys.argv) != 4:
        print("Usage: generate_yaml.py <schema-file> <output-dir> <project-name>")
        sys.exit(1)

    schema_file = sys.argv[1]
    output_dir = sys.argv[2]
    project_name = sys.argv[3]

    generate_yaml_with_defaults(schema_file, output_dir, project_name)

if __name__ == "__main__":
    main()
