#!/bin/bash
rm current_coin.log
while true
do
#Location of switch.sh / should be same as config.json
/root/xmrig-proxy-6.10.1/switch.sh
sleep 15
done

#Create a cronjob for this to screen @reboot
#@reboot screen -dmS switch /root/xmrig-proxy-6.10.1/loop_switch.sh
