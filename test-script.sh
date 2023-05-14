#!/bin/bash

echo "===================================="
echo "This is a Test Script"
echo "===================================="

echo "Enter your specified directory: "
read -r -e DIR
    if [[ -z "$DIR" ]]; then
        readlink -f "$DIR"
    else
        echo "Please specify a directory..."
        exit 1
    fi

echo "Enter the Name of the file you would like created: "
read -r -e FILE

touch /tmp/"$FILE"
cp -a /tmp/"$FILE" "$DIR"