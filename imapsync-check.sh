#!/bin/bash

# Colours
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

SAVEIFS=$IFS    # Backing up the delimiter used by arrays to differentiate between different data in the array (prior to changing it)
IFS=$'\n'       # Changing the delimiter used by arrays from a space to a new line, this allows a list of users (on new lines) to be stored in to an array

EMAIL_LIST_FOR_REPORT=()

for EMAIL_MIGRATION in $(cat sync-list.txt)
do
        EMAIL_ADDRESS=$(echo "$EMAIL_MIGRATION" | awk '{print $5}')
        echo "$EMAIL_MIGRATION" | sh

        if [ `echo $?` != 0 ]
        then
                echo -e "
                The following command just failed:
                ${RED}$EMAIL_MIGRATION${NC}

                Please rectify the issue so that it can proceed with the rest..."
                EMAIL_LIST_FOR_REPORT+=("ERROR - $EMAIL_ADDRESS")

                echo "Report:"
                printf '%s\n' "${EMAIL_LIST_FOR_REPORT[@]}"
                exit 1
        else
                EMAIL_LIST_FOR_REPORT+=("OK - $EMAIL_ADDRESS")
        fi
done

echo -e "\n ### Migration Summary ###\n"
printf '%s\n' "${EMAIL_LIST_FOR_REPORT[@]}"

IFS=$SAVEIFS # Resets $IFS this changes the delimiter that arrays use from new lines (\n) back to just spaces (which is what it normally is)

exit 0
