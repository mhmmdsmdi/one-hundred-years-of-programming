#!/bin/bash

echo "Choose Docker image import method:"
echo "1) Import from .tar files in current directory"
echo "2) Import from .7z archive"

read -rp "Enter your choice [1 or 2]: " method

if [[ "$method" == "1" ]]; then
  echo "Importing from .tar files in current directory..."
  for file in *.tar; do
    [ -e "$file" ] || continue  # Skip if no .tar files found
    echo "Loading $file..."
    docker load -i "$file" && rm -f "$file"
  done
  echo "Done importing from .tar files."

elif [[ "$method" == "2" ]]; then
  # List all .7z files
  mapfile -t files < <(find . -maxdepth 1 -type f -name "*.7z" -printf "%f\n")

  if [ ${#files[@]} -eq 0 ]; then
    echo "No .7z files found in the current directory."
    exit 1
  fi

  echo "Select a .7z file to extract and import Docker images:"
  select filename in "${files[@]}"; do
    if [[ -n "$filename" ]]; then
      echo "You selected: $filename"
      break
    else
      echo "Invalid selection."
    fi
  done

  # Create temp dir
  tmpdir="extracted_${filename%.*}_$$"
  mkdir "$tmpdir"

  # Extract and check
  echo "Extracting $filename..."
  7z x "$filename" -o"$tmpdir"
  if [ $? -ne 0 ]; then
    echo "Extraction failed."
    rm -rf "$tmpdir"
    exit 1
  fi

  # Load extracted .tar files
  echo "Importing Docker images..."
  for tarfile in "$tmpdir"/*.tar; do
    [ -e "$tarfile" ] || continue
    echo "Loading $tarfile..."
    docker load -i "$tarfile"
  done

  # Move .7z file to 'imported' directory
  target_dir="./imported"
  mkdir -p "$target_dir"
  echo "Moving $filename to $target_dir..."
  mv "$filename" "$target_dir/"

  # Clean up
  echo "Removing extracted directory..."
  rm -rf "$tmpdir"

  echo "Done importing from .7z archive."

else
  echo "Invalid option selected. Exiting."
  exit 1
fi
