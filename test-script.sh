#!/bin/bash

echo "===================================="
echo "This is a Test Script"
echo "===================================="

echo "Enter your specified directory: "
read -r -e DIR
    if [[ -e "$DIR" ]]; then
        readlink -f "$DIR"
    else
        echo "Please specify an absolute path or directory name..."
        exit 1
    fi

echo "Enter the Name of the file you would like created: "
read -r -e FILE

touch /tmp/"$FILE"
cp -a /tmp/"$FILE" "$DIR"