#!/bin/bash

URL="https://onlinebusiness.icbc.com/qmaticwebbooking"
SERVICE="C. Apply for learner's licence and take knowledge test for up to 2 licence classes"
BRANCH="Port Coquitlam"
COUNT=10
PREFERABLEDATE="2024-03-30"

SHOWSERVICES=0
SHOWBRANCH=0
SHOWTOP10=0
SHOWPREFDATE=1

#curl https://onlinebusiness.icbc.com/qmaticwebbooking/rest/schedule/serviceGroups 2>/dev/ | jq

if [ -z $SHOWSERVICES ]; then
    curl "$URL/rest/schedule/serviceGroups" 2>/dev/null \
        | jq ".[].services[].name"
fi

PUBLICID=$(curl "$URL/rest/schedule/serviceGroups" 2>/dev/null \
            | jq ".[].services[] | select(.name==\"$SERVICE\") | .publicId" \
            | tr -d \")

DURATION=$(curl "$URL/rest/schedule/serviceGroups" 2>/dev/null \
            | jq ".[].services[] | select(.name==\"$SERVICE\") | .duration" \
            | tr -d \")

#curl 'https://onlinebusiness.icbc.com/qmaticwebbooking/rest/schedule/branches/available;servicePublicId=de4aa576658ca2567d913bd7cb51461c1932c80f9eab6661dc8896434004c645'

if [ -z $SHOWBRANCH ]; then
    curl "$URL/rest/schedule/branches/available;servicePublicId=$PUBLICID" 2>/dev/null \
        | jq ".value[].name"
fi

BRANCHID=$(curl "$URL/rest/schedule/branches/available;servicePublicId=$PUBLICID" 2>/dev/null \
            | jq ".value[] | select(.name==\"$BRANCH\") | .id" \
            | tr -d \")

#curl 'https://onlinebusiness.icbc.com/qmaticwebbooking/rest/schedule/branches/57e82b0d3611dcc4a62cf042b7165c0cbd9b3ffb4276527f828ff317ac02a425/dates;servicePublicId=de4aa576658ca2567d913bd7cb51461c1932c80f9eab6661dc8896434004c645;customSlotLength=35'

if [ -z $SHOWTOP10 ]; then
    curl "$URL/rest/schedule/branches/$BRANCHID/dates;servicePublicId=$PUBLICID;customSlotLength=$DURATION" 2>/dev/null \
        | jq ".[].date" \
        | tr -d \" \
        | head -n $COUNT \
        | while read DATE; do
            curl "$URL/rest/schedule/branches/$BRANCHID/dates/$DATE/times;servicePublicId=$PUBLICID;customSlotLength=$DURATION" 2>/dev/null \
            | jq -c ".[]"
          done \
        | head -n $COUNT
fi
#curl 'https://onlinebusiness.icbc.com/qmaticwebbooking/rest/schedule/branches/57e82b0d3611dcc4a62cf042b7165c0cbd9b3ffb4276527f828ff317ac02a425/dates/2024-03-25/times;servicePublicId=de4aa576658ca2567d913bd7cb51461c1932c80f9eab6661dc8896434004c645;customSlotLength=35'

if [ -z $SHOWPREFDATE ]; then 
    curl "$URL/rest/schedule/branches/$BRANCHID/dates/$PREFERABLEDATE/times;servicePublicId=$PUBLICID;customSlotLength=$DURATION" 2>/dev/null
fi