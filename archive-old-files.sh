#!/bin/bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

DIR="$1"

if [ ! -d "$DIR" ]; then
  echo "Error: Directory does not exist."
  exit 1
fi

ARCHIVE_DIR="$DIR/archive"

mkdir -p "$ARCHIVE_DIR"

# Find files older than 5 days and move them
find "$DIR" -maxdepth 1 -type f -mtime +5 -exec mv {} "$ARCHIVE_DIR" \;

echo "Archived files older than 5 days into $ARCHIVE_DIR"