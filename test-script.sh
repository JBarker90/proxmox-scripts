#!/bin/bash

echo "===================================="
echo "This is a Test Script"
echo "===================================="

echo "Enter your specified directory: "
read -r -e DIR

echo "Enter the Name of the file you would like created: "
read -r -e FILE

touch /tmp/"$FILE"
cp -a /tmp/"$FILE" "$DIR"