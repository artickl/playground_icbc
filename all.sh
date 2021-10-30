#!/bin/bash

FOLDER=$(dirname "${BASH_SOURCE[0]}")
cd $FOLDER

pipenv run python -m pytest -s tests/test_icbc.py \
    | tee -a all.log \
    | grep '\[I\]:' \
    | grep -e "October" -e "November" -e "December" -e "January" \
    | while read line; do 
            tests/telegram.sh "$line" >> all.log 
        done
