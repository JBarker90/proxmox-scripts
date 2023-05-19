#!/bin/bash

generate_random_string() {
  local random_string
  random_string=$(cat /dev/urandom | tr -dc '[:graph:]' | head -c 65)
  echo "$random_string"
}

words=("apple" "banana" "cherry" "date" "elderberry")

# Generate random strings using words from the array
for word in "${words[@]}"; do
    echo -e "\nGenerating random strings: "
    random_string=$(generate_random_string)
    echo "Random $word string: $random_string"
done

# Generate 5 random strings for each word
for word in "${words[@]}"; do
    echo -e "\nGenerating 5 random strings for each word: "
    echo "Word: $word"
    for ((i=1; i<=5; i++)); do
        random_string=$(generate_random_string)
        echo "Random $word string $i: $random_string"
    done
done