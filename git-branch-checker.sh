#!/bin/bash

# Get all local branches
branches=$(git branch --format="%(refname:short)")

# Loop through each branch
for branch in $branches; do
    if [[ "$branch" == *feature* || "$branch" == *fix* || "$branch" == *docs* ]]; then
        echo "$branch : GOOD"
    else
        echo "$branch : BAD"
    fi
done
