#!/bin/bash

# Colours
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

SAVEIFS=$IFS    # Backing up the delimiter used by arrays to differentiate between different data in the array (prior to changing it)
IFS=$'\n'       # Changing the delimiter used by arrays from a space to a new line, this allows a list of users (on new lines) to be stored in to an array

for EMAIL_MIGRATION in $(cat sync-list.txt)
do
        echo "$EMAIL_MIGRATION" | sh

        if [ `echo $?` != 0 ]
        then
                echo -e "
                The following command just failed:
                ${RED}$EMAIL_MIGRATION${NC}

                Please rectify the issue so that it can proceed with the rest..."
                exit 1
        fi
done

IFS=$SAVEIFS # Resets $IFS this changes the delimiter that arrays use from new lines (\n) back to just spaces (which is what it normally is)