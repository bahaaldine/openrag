import json
import yaml
import jsonschema
from jsonschema import validate
import os
import sys

def load_yaml(filename):
    with open(filename, 'r') as file:
        return yaml.safe_load(file)

def load_json_schema(schema_filename):
    with open(schema_filename, 'r') as file:
        return json.load(file)

def validate_yaml(yaml_data, json_schema):
    try:
        validate(instance=yaml_data, schema=json_schema)
        print(f"Validation successful for {yaml_data['metadata']['name']}.")
    except jsonschema.exceptions.ValidationError as err:
        print("Validation failed.")
        print(err)

def main(yaml_file):
    # Assume the schema file is always in the /schema directory
    schema_file = os.path.join(os.path.dirname(__file__), 'schema', 'openrag-schema.json')

    yaml_data = load_yaml(yaml_file)
    json_schema = load_json_schema(schema_file)

    validate_yaml(yaml_data, json_schema)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: openrag make <yaml-file>")
        sys.exit(1)

    main(sys.argv[1])
