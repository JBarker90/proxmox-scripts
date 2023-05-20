#!/bin/bash

# Generate new salts
WP_DIR=$(readlink -f "$1")

GENERATE_NEW_SALTS(){
    local NEW_SALTS
    NEW_SALTS=$(< /dev/urandom tr -dc '[:graph:]' | head -c 65)
    echo "$NEW_SALTS"
}
OLD_SALTS=$(grep -iE 'auth|key|salt' "$WP_DIR" | grep -v '\*' | awk -F\' '{print $4}')
#OLD_SALTS=$(grep -iE 'auth|key|salt' "$WP_DIR" | grep -v '\*' | awk -F\' '{print $4}' | sed "s/.*/'&'/")
#echo -e "Your old Salts are: \n$OLD_SALTS"

# Store the salts in an array
IFS=$'\n' read -r -d '' -a SALT_ARRAY <<< "$OLD_SALTS"

for salt in "${SALT_ARRAY[@]}"; do
    echo "Your old Salts are: $salt"
    NEW_SALTS=$(GENERATE_NEW_SALTS)
    echo -e "Your new Salt is: $NEW_SALTS\n"
done

#for salt in "${SALT_ARRAY[@]}"; do
    #echo "Your old Salts are: $salt"
#    NEW_SALTS1=$(GENERATE_NEW_SALTS)
#    NEW_SALTS2=$(GENERATE_NEW_SALTS)
#    NEW_SALTS3=$(GENERATE_NEW_SALTS)
#    NEW_SALTS4=$(GENERATE_NEW_SALTS)
#    NEW_SALTS5=$(GENERATE_NEW_SALTS)
#    NEW_SALTS6=$(GENERATE_NEW_SALTS)
#    NEW_SALTS7=$(GENERATE_NEW_SALTS)
#    NEW_SALTS8=$(GENERATE_NEW_SALTS)
#    sed -i "s/'$salt'/'$NEW_SALTS1'/g" "$WP_DIR"
#    sed -i "s/'$salt'/'$NEW_SALTS2'/g" "$WP_DIR"
#    sed -i "s/'$salt'/'$NEW_SALTS3'/g" "$WP_DIR"
#    sed -i "s/'$salt'/'$NEW_SALTS4'/g" "$WP_DIR"
#    sed -i "s/'$salt'/'$NEW_SALTS5'/g" "$WP_DIR"
#    sed -i "s/'$salt'/'$NEW_SALTS6'/g" "$WP_DIR"
#    sed -i "s/'$salt'/'$NEW_SALTS7'/g" "$WP_DIR"
#    sed -i "s/'$salt'/'$NEW_SALTS8'/g" "$WP_DIR"
#done

#for salt in "${OLD_SALTS[@]}"
#do
#    NEW_SALTS=$(GENERATE_NEW_SALTS)
#    sed -i "s/'$salt'/'$NEW_SALTS'/g" "$WP_DIR"
#done