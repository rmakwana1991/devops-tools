#!/bin/bash
#Maintainer rohanmakwana09101991@gmail.com
#This script will monitor the process and port usage of the system
PROCESS_NAME="nginx"
PORT_NUMBER="80"
EMAIL_ID="rohanmakwana09101991@gmail.com"
APP_PASSWORD="jtga sxmc ampk wxqk"

echo "Process and Port Monitoring Started"

#Function for sending the email to gmail via curl

send_email() {
    SUBJECT="$1"
    BODY="$2"
    curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
      --mail-from "$EMAIL_ID" \
      --mail-rcpt "$EMAIL_ID" \
      --user "$EMAIL_ID:$APP_PASSWORD" \
      -T <(echo -e "From: $EMAIL_ID\nTo: $EMAIL_ID\nSubject: $SUBJECT\n\n$BODY")
}

#Process Monitoring
if ps aux | grep -v grep | grep "$PROCESS_NAME" > /dev/null
then
    echo "$PROCESS_NAME is running."
else
    echo "$PROCESS_NAME is not running."
    send_email "Process Monitoring Alert" "$PROCESS_NAME is not running."
fi

#Port Monitoring
if netstat -tuln | grep -q ":$PORT_NUMBER "
then
    echo "Port $PORT_NUMBER is in use."
else
    echo "Port $PORT_NUMBER is not in use."
    send_email "Port Monitoring Alert" "Port $PORT_NUMBER is not in use."
fi

#Port Monitoring
#if lsof -i :"$PORT_NUMBER" > /dev/null
#then
#    echo "Port $PORT_NUMBER is in use."
#else
#    echo "Port $PORT_NUMBER is not in use."
#    send_email "Port Monitoring Alert" "Port $PORT_NUMBER is not in use."
#fi

echo "Process and Port Monitoring completed"