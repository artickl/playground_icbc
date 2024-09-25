#!/bin/bash

URL="https://onlinebusiness.icbc.com/qmaticwebbooking"
COUNT=10

# expecting no arguments on first try
SHOWSERVICES=""
SHOWBRANCH=""
SHOWTOP10=""
SHOWPREFDATE=""

Help()
{
   # Display Help
   echo "Show ICBC appolintments for their simple service: https://onlinebusiness.icbc.com/qmaticwebbooking/#/"
   echo
   echo "Syntax: $0 [-s|l|d|h]"
   echo "options:"
   echo "s     Specify service. If blank - will show a list of all available services."
   echo "l     Specify location. Can't be used without specifying service. If blank - will show all available locations."
   echo "d     Specify date. Can't be used without specifyng service and location. If blank - will show next 10 available timeframes"
   echo "h     Print this Help."
   echo
   echo "EXAMPLES:"
   echo "Simply see if tomorrow Surrey has any lost driver replacement window, you can run the following:"
   echo "$ ./new_icbc.sh -s \"B. Replace a lost/stolen/damaged DL\" -l \"Surrey\" -d \"2024-06-27\""
   echo "  {"
   echo "    \"date\": \"2024-06-27\","
   echo "    \"time\": \"11:50\""
   echo "  }"
   echo ""
   echo "If you want to see next available option for specific service in any location, you can run a little bit more complicated example:"
   echo "$ ./new_icbc.sh -s \"B. Replace a lost/stolen/damaged DL\" | sed '1d;s/\"//g' | while read line; do echo -n \"$line: \"; ./new_icbc.sh -s \"B. Replace a lost/stolen/damaged DL\" -l \"$line\" | sed '1d' | head -n 1; done"
   echo ""
   echo '	Abbotsford: {"date":"2024-06-26","time":"10:10"}'
   echo '	Burnaby: {"date":"2024-06-25","time":"11:50"}'
   echo '	East Van: {"date":"2024-06-26","time":"09:30"}'
   echo '	Guildford: {"date":"2024-06-20","time":"12:20"}'
   echo '	Kamloops: {"date":"2024-06-21","time":"14:10"}'
   echo '	Kelowna: {"date":"2024-07-02","time":"14:50"}'
   echo '	Langley-Willowbrook: {"date":"2024-07-09","time":"11:20"}'
   echo '	Metrotown: {"date":"2024-06-21","time":"11:20"}'
   echo '	Nanaimo: {"date":"2024-06-20","time":"12:20"}'
   echo '	North Vancouver: {"date":"2024-06-25","time":"13:50"}'
   echo '	Point Grey: {"date":"2024-06-26","time":"10:20"}'
   echo '	Port Coquitlam: {"date":"2024-06-25","time":"14:40"}'
   echo '	Richmond: {"date":"2024-06-28","time":"09:20"}'
   echo '	Royal Centre: {"date":"2024-06-26","time":"13:10"}'
   echo '	Surrey: {"date":"2024-06-25","time":"13:10"}'
   echo '	Victoria - McKenzie Ave: {"date":"2024-06-20","time":"13:20"}'
   echo '	Victoria - Wharf St: {"date":"2024-06-20","time":"13:40"}'
}

while getopts "s:l:d:h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      s) # Enter service
	 SERVICE=$OPTARG
         SHOWSERVICES=0
	 ;;
      l) # Enter location
	 BRANCH=$OPTARG
	 SHOWBRANCH=0
	 ;;
      d) # Enter date
	 PREFERABLEDATE=$OPTARG
	 SHOWTOP10=0
	 SHOWPREFDATE=""
	 ;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

#curl https://onlinebusiness.icbc.com/qmaticwebbooking/rest/schedule/serviceGroups 2>/dev/ | jq

if [ -z $SHOWSERVICES ]; then
    echo "Please use any of this services in '-s' parameter:"
    curl "$URL/rest/schedule/serviceGroups" 2>/dev/null \
        | jq ".[].services[].name"
    exit
fi

PUBLICID=$(curl "$URL/rest/schedule/serviceGroups" 2>/dev/null \
            | jq ".[].services[] | select(.name==\"$SERVICE\") | .publicId" \
            | tr -d \" | sort | uniq)

DURATION=$(curl "$URL/rest/schedule/serviceGroups" 2>/dev/null \
            | jq ".[].services[] | select(.name==\"$SERVICE\") | .duration" \
            | tr -d \" | sort | uniq)

#curl 'https://onlinebusiness.icbc.com/qmaticwebbooking/rest/schedule/branches/available;servicePublicId=de4aa576658ca2567d913bd7cb51461c1932c80f9eab6661dc8896434004c645'

if [ -z $SHOWBRANCH ]; then
    echo "Showing all locations for $SERVICE. Please use any of this locations in '-l' parameter:"

    curl "$URL/rest/schedule/branches/available;servicePublicId=$PUBLICID" 2>/dev/null \
        | jq ".value[].name"
    exit
fi

BRANCHID=$(curl "$URL/rest/schedule/branches/available;servicePublicId=$PUBLICID" 2>/dev/null \
            | jq ".value[] | select(.name==\"$BRANCH\") | .id" \
            | tr -d \")

#curl 'https://onlinebusiness.icbc.com/qmaticwebbooking/rest/schedule/branches/57e82b0d3611dcc4a62cf042b7165c0cbd9b3ffb4276527f828ff317ac02a425/dates;servicePublicId=de4aa576658ca2567d913bd7cb51461c1932c80f9eab6661dc8896434004c645;customSlotLength=35'

if [ -z $SHOWTOP10 ]; then
    
    echo "Showing first 10 timeslots for $SERVICE in $BRANCH. If you want to see specific date, please use it in '-d' parameter:"
    curl "$URL/rest/schedule/branches/$BRANCHID/dates;servicePublicId=$PUBLICID;customSlotLength=$DURATION" 2>/dev/null \
        | jq ".[].date" \
        | tr -d \" \
        | head -n $COUNT \
        | while read DATE; do
            curl "$URL/rest/schedule/branches/$BRANCHID/dates/$DATE/times;servicePublicId=$PUBLICID;customSlotLength=$DURATION" 2>/dev/null \
            | jq -c ".[]"
          done \
        | head -n $COUNT
    exit
fi
#curl 'https://onlinebusiness.icbc.com/qmaticwebbooking/rest/schedule/branches/57e82b0d3611dcc4a62cf042b7165c0cbd9b3ffb4276527f828ff317ac02a425/dates/2024-03-25/times;servicePublicId=de4aa576658ca2567d913bd7cb51461c1932c80f9eab6661dc8896434004c645;customSlotLength=35'

if [ -z $SHOWPREFDATE ]; then 
    RESULT=$(curl "$URL/rest/schedule/branches/$BRANCHID/dates/$PREFERABLEDATE/times;servicePublicId=$PUBLICID;customSlotLength=$DURATION" 2>/dev/null \
	    | jq | sed 's/^\[\]$//')
fi

if [ "$RESULT" ]; then
    echo -e "$BRANCH (service: $SERVICE) has the following times on $PREFERABLEDATE now: $(echo $RESULT \
        | jq ".[].time" \
        | tr '\n' '|' \
        | sed 's/|$//;s/|/, /g'). Open $URL!"
fi