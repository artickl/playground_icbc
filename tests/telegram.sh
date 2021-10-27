#!/bin/bash

. ./telegram.ini

curl https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/getUpdates | jq .message.chat.id