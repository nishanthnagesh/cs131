#!/bin/bash

echo "Enter ZIP file URL:"
read url

while [ -z "$url" ]; do
  echo "Please enter a URL:"
  read url
done

echo "Downloading..."
curl -L -O "$url"

zip_file=$(basename "$url")
file_type=$(file "$zip_file")
#Check if downloaded file is a valid zip
if echo "$file_type" | grep -q "Zip archive"; then
  echo "File is a valid ZIP archive."
else
  echo "Error: Not a ZIP file."
  exit 1
fi

#check if zip contains CSVs and extract them
if unzip -l "$zip_file" | grep -q ".csv"; then
  echo "CSV file(s) found in ZIP."
  mkdir -p unzip_files
  if unzip -o -j "$zip_file" '*.csv' -d unzip_files; then
    echo "CSV files extracted to ./unzip_files/"
  else
    echo "Error: Failed to unzip."
    exit 1
  fi
else
  echo "Error: No CSV files found in the ZIP."
  exit 1
fi
#clear prior summary output
rm -f  summary.md
#run awk script on each CSV and append output
for file in ./unzip_files/*.csv; do
    echo $file
     awk -F \; -f awkscript $file $file >> summary.md
done
