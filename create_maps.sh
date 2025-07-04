#!/bin/bash

# Check if both input and output folders are provided as arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_folder> <output_folder>"
    exit 1
fi

# Assign input and output folders from arguments
input_folder="$1"
output_folder="$2"

# Create the output folder if it doesn't exist
mkdir -p "$output_folder"

# Get the directory of the script (so the XSLT file is always relative to the script location)
script_dir=$(dirname "$0")

# Set the path to the XSLT file (assumes it's in the same directory as the script)
xslt_file_table="$script_dir/xsl/table-map.xsl"
xslt_file_field="$script_dir/xsl/field-map.xsl"

# Check if the XSLT files exist
if [ ! -f "$xslt_file_table" ]; then
    echo "XSLT file not found: $xslt_file_table"
    exit 1
fi
if [ ! -f "$xslt_file_field" ]; then
    echo "XSLT file not found: $xslt_file_field"
    exit 1
fi

# Set the output file names
output_file_table="$output_folder/table_map.csv"
output_file_field="$output_folder/field_map.csv"

# Start with empty output files (or create a new one)
> "$output_file_table"
> "$output_file_field"

# Add header rows
echo "db,table_id,table_name" >> "$output_file_table"
echo "db,field_id,field_name,table_id,table_name" >> "$output_file_field"

# Loop through all .xml files in the input folder
for input_file in "$input_folder"/*.xml; do
    # Check if there are any XML files
    if [ ! -f "$input_file" ]; then
        echo "No XML files found in $input_folder"
        exit 1
    fi

    # Apply the XSLT transformations to the current input file
    # Append the result to the output files
    xsltproc "$xslt_file_table" "$input_file" >> "$output_file_table"
    xsltproc "$xslt_file_field" "$input_file" >> "$output_file_field"
done

echo "Maps saved to $output_file_table and $output_file_field"
