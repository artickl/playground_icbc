#!/bin/bash

cd /home/artemzavyalov/git/playground_icbc

pipenv run python -m pytest -s tests/test_icbc.py \
    | grep '\[I\]:' \
    | grep -e "October" -e "November" -e "December" -e "January" \
    | while read line; do 
            tests/telegram.sh "$line"; 
        done