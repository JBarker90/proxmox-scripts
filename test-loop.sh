#!/bin/bash

# Generate new salts
WP_DIR=$(readlink -f "$1")

GENERATE_NEW_SALTS(){
    local NEW_SALTS
    NEW_SALTS=$(< /dev/urandom tr -dc '[:graph:]' | head -c 65)
    echo "$NEW_SALTS"
}

OLD_SALTS=("put your unique phrase here")

for salt in "${OLD_SALTS[@]}"
do
    NEW_SALTS=$(GENERATE_NEW_SALTS)
    sed -i "s/'$salt'/'$NEW_SALTS'/g" "$WP_DIR"
done