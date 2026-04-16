#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: ./l33t.sh <file>"
  exit 1
fi

sed -e 's/e/3/g' \
    -e 's/t/7/g' \
    -e 's/o/0/g' \
    -e 's/i/1/g' "$1"
