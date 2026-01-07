# Python Scripts

This folder contains small Python scripts designed to simulate real-world scripting tasks.
These scripts focus on automation, file handling, arguments, and validation.

## Files in this folder

### check_args.py
A script that captures command-line arguments using sys.argv.
It:
- prints the script name
- checks if arguments were passed
- prints argument count and values

This helped me understand how Python scripts receive input from the terminal.

### json2yaml.py
Converts a JSON file into YAML format.
This script:
- loads JSON into a Python dictionary
- converts the dictionary to YAML
- prints or saves the output depending on arguments

### validate_json_file.py
Validates a single JSON file by:
- checking it loads correctly
- checking required fields exist

### validate_all_json_files.py
Validates all JSON files inside a folder.
This uses loops to:
- iterate through files
- attempt to load each JSON file
- report VALID or INVALID

### run_script.py / Script.py
Used to practise running Python scripts and understanding script execution flow.

## Key learning points
- sys.argv allows scripts to accept terminal input
- JSON is converted into Python dictionaries for processing
- Validation is logic written by the developer, not automatic