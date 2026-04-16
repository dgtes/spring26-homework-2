#!/bin/bash

read -p "Repository Name: " repo 
read -p "Your name: " name
read -p "Your email: " email


read -p "Do you want a .gitignore file? [y/n] " gitignore
read -p "Do you want a README.md file? [y/n] " readme

mkdir "$repo"
cd "$repo" || exit

git init

git config user.name "$name"
git config user.email "$email"

if [[ "$gitignore" == "y" ]]; then
	touch .gitignore
fi

if [[ "$readme" == "y" ]]; then
	echo "# $repo" > README.md
fi

echo "Repository '$repo' created. cd into it to get started!" 
