#!/bin/bash
#Maintainer rohanmakwana09101991@gmail.com
#This script will monitor the CPU, RAM and Storage usage of the system
#Variables
CPU_THRESHOLD=90
RAM_THRESHOLD=90
STORAGE_THRESHOLD=90
EMAIL_ID="rohanmakwana09101991@gmail.com"
APP_PASSWORD="jtga sxmc ampk wxqk"

echo "CPU, RAM and Storage usage of the system"
echo "The current date and time is: $(date)"

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

#check the cpu usage based on the current usage and send the email to gmail using function and if condition on 90% Threshold
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
CPU_USAGE_INT=${CPU_USAGE%.*}
if [ "$CPU_USAGE_INT" -gt "$CPU_THRESHOLD" ]; then
    send_email "CPU Usage Alert" "CPU usage is above the threshold of $CPU_THRESHOLD%. Current usage: $CPU_USAGE_INT%."
fi
#check the RAM usage based on the current usage and send the email to gmail using function and if condition on 90% Threshold
RAM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
RAM_USAGE_INT=${RAM_USAGE%.*}
if [ "$RAM_USAGE_INT" -gt "$RAM_THRESHOLD" ]; then
    send_email "RAM Usage Alert" "RAM usage is above the threshold of $RAM_THRESHOLD%. Current usage: $RAM_USAGE_INT%."
fi
#check the Storage usage based on the current usage and send the email to gmail using function and if condition on 90% Threshold
STORAGE_USAGE=$(df -h / | awk 'NR==2 {print $5}'| tr -d '%')
STORAGE_USAGE_INT=${STORAGE_USAGE%.*}
if [ "$STORAGE_USAGE_INT" -gt "$STORAGE_THRESHOLD" ]; then
    send_email "Storage Usage Alert" "Storage usage is above the threshold of $STORAGE_THRESHOLD%. Current usage: $STORAGE_USAGE_INT%."
fi
echo "Monitoring completed."
