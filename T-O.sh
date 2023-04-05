#!/bin/bash

# prompt user for input file
read -p "Enter the path to the input file: " input_file

# check if input file exists
if [ ! -f "$input_file" ]; then
  echo "Error: Input file does not exist."
  exit 1
fi

# prompt user for directory containing subdomain takeover tools
read -p "Enter the path to the directory containing the subdomain takeover tools: " tool_dir

# check if tool directory exists
if [ ! -d "$tool_dir" ]; then
  echo "Error: Tool directory does not exist."
  exit 1
fi

# create results file
results_file="results.txt"
touch "$results_file"

# loop through each line in the input file
while read -r line; do

  # run SubOver on the line
  subover_result=$(python3 "$tool_dir/SubOver/subover.py" -l "$line")

  # run Subzy on the line
  subzy_result=$(python3 "$tool_dir/subzy/subzy.py" "$line")

  # run TKO Subs on the line
  tkosubs_result=$(python3 "$tool_dir/tko-subs/tko-subs.py" -domains "$line")

  # write the results to the output file
  echo "$line" >> "$results_file"
  echo "$subover_result" >> "$results_file"
  echo "$subzy_result" >> "$results_file"
  echo "$tkosubs_result" >> "$results_file"

done < "$input_file"

# remove duplicate lines from the results file
sort -u "$results_file" -o "$results_file"

echo "Subdomain takeover test complete. Results saved to $results_file."
