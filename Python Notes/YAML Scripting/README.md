# YAML Scripting

This folder focuses on working with YAML files and converting between YAML and JSON.
These scripts build directly on the JSON scripting concepts.

## Files in this folder

### parse_json_to_dict.py
Loads a structured data file and converts it into a Python dictionary.
This helped reinforce how Python sits between file formats and logic.

### validate_all_yaml_files.py
Loops through a folder and checks whether each YAML file is valid.
It:
- attempts to load each YAML file
- prints VALID or INVALID for each file
- uses try / except to prevent crashes

### validate_json_file2.py
An alternative validation script used to practise similar validation logic across formats.

## Key learning points
- YAML and JSON are both structured data formats
- Python dictionaries are used as the middle step
- try / except is essential for safe file processing