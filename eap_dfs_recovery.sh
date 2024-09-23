#!/bin/sh

#EAP DFS Event recovery script  v20240923.0
#https://github
#
#    * change http to https in curl lines if enabled
#
#Formatting for freebsd, linux/bash may require minor formatting changes
#    * "-ne" in comparison check instead of "=="
#
#

###########################################
#for reference, 5Ghz Channel numbers
<<comment
0  auto
1  36
2  40
3  44
4  48
5  52
6  56
7  60
8  64
9  100
10 104
11 108
12 112
13 116
14 120
15 124
16 128
17 132
18 136
19 140
20 149
21 153
22 157
23 161
24 165
comment
###########################################

EAP_HOST="{EAP resolvable hostname or ip address}"
USERNAME="{username, usually admin}"
PASSWORD="{32 character password}"

#5ghz channel number to revert back to
DESIRED_CHANNEL="100"
#5ghz channel id - see chart above for corresponding id number, ie 9 is for ch 100
DESIRED_CHANNEL_ID="9"

#See readme for instructions to obtain these values
WIRELESS_MODE=16
CHANNEL_WIDTH=7
CHANNELLIMIT=0
TXPOWER=28
IS_APMODE=1
RADIOID=1

#Obtain session ID cookie
SESSION_ID=$(curl -k -Ss "http://$EAP_HOST/" -X POST --data-raw 'username='$USERNAME'&password='$PASSWORD'' --cookie-jar - | grep "SESSION" | cut -f 7)

#Read current channel
#CURRENT_CHANNEL=$(curl -sS "http:/$EAP_HOST/data/status.wireless.radio.json?operation=read&radioID=1" -H "Referer: http://$EAP_HOST/" -H "Cookie: JSESSIONID=$SESSION_ID" | grep "channel" | awk '{print $2}' | cut -c 2-4 )

CURRENT_CHANNEL=$(curl -k -Ss "http:/$EAP_HOST/data/status.wireless.radio.json?operation=read&radioID=1" -H 'Referer: http://'$EAP_HOST'/' -H 'Cookie: JSESSIONID='$SESSION_ID'' | grep "channel" | awk '{print $2}' | cut -c 2-4 )

#for debugging, normally disabled
#echo $EAP_HOST $USERNAME $PASSWORD $SESSION_ID $CURRENT_CHANNEL

if [ $CURRENT_CHANNEL != $DESIRED_CHANNEL ]
  then
        logger -s -t "dfs" "$EAP_HOST DFS event occurred, check log; current channel $CURRENT_CHANNEL"
        curl -k -Ss "http://$EAP_HOST/data/wireless.basic.json" -X POST -H "Referer: http://$EAP_HOST/" -H "Cookie: JSESSIONID=$SESSION_ID" --data-raw "operation=write&wireless_mode=$WIRELESS_MODE&chan_width=$CHANNEL_WIDTH&channelLimit=$CHANNELLIMIT&channel=$DESIRED_CHANNEL_ID&txpower=$TXPOWER&is_apmode=$IS_APMODE&radioID=$RADIOID" -o /dev/null
        CURRENT_CHANNEL_NEW=$(curl -k -Ss "http:/$EAP_HOST/data/status.wireless.radio.json?operation=read&radioID=1" -H 'Referer: http://'$EAP_HOST'/' -H 'Cookie: JSESSIONID='$SESSION_ID'' |  grep "channel" | awk '{print $2}' | cut -c 2-4 )
        logger -s -t "dfs" "$EAP_HOST Channel set to back to channel $CURRENT_CHANNEL_NEW."
fi
