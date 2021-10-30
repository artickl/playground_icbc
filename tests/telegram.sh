#!/bin/bash

FOLDER=$(dirname "${BASH_SOURCE[0]}")

. $FOLDER/telegram.ini

if [ "X$CHATID" == "X" ]; then
    curl https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/getUpdates 2>/dev/null \
        | $FOLDER/jq '.result[].message.chat.id' \
        | xargs -I {} sed -i "s/CHATID=.*/CHATID={}/g" $FOLDER/telegram.ini
fi

echo "$1"
echo $CHATID
echo $TELEGRAM_BOT_TOKEN

curl -X POST \
     -H 'Content-Type: application/json' \
     -d "{\"chat_id\": \"$CHATID\", \"text\": \"$1\"}" \
     https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage 2>/dev/null
