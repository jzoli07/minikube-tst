#!/bin/bash

echo "!!!BEGIN!!!"
#echo "$@"
JSON=$1
SUBJECT="ALERT"
TO="kubestackpromzoltan@gmail.com"

receiver=$(echo $JSON | jq -r .receiver)
status=$(echo $JSON | jq -r .alerts[0].status)
severity=$(echo $JSON | jq -r .alerts[0].labels.severity)
alertname=$(echo $JSON | jq -r .alerts[0].labels.alertname)
instance=$(echo $JSON | jq -r .alerts[0].labels.instance)
job=$(echo $JSON | jq -r .alerts[0].labels.job)

if [[ "$status" == "firing" ]]; then
	statustxt="OPEN"
else
	statustxt="CLOSE"
fi

BODY="receiver=$receiver\n"
BODY+="status=$status\n"
BODY+="severity=$severity\n"
BODY+="alertname=$alertname\n"
BODY+="instance=$instance\n"
BODY+="job=$job"

echo -e $BODY | mail -s $SUBJECT:$alertname:$statustxt:$severity $TO
echo "!!!END!!!" 

exit 0
