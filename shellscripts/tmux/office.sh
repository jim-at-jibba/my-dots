#!/bin/bash

# This script subscribes to a MQTT topic using mosquitto_sub.
# On each message received, you can execute whatever you want.

while true  # Keep an infinite loop to reconnect when connection lost/broker unavailable
do
    mosquitto_sub -h hairdresser.cloudmqtt.com -u "iscqccyj" -P "WNadSQVdUR8C" -t "environ/office-grow" -p 15656 | while read -r payload
    do
        # Here is the callback to execute whenever you receive a message:
        jq -r $payload
        # echo "Rx MQTT: ${payload}"
    done
    sleep 10  # Wait 10 seconds until reconnection
done # &  # Discomment the & to run in background (but you should rather run THIS script in background)
