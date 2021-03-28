#!/bin/bash
#Uses ./loop_switch.sh in a screen to run every 15 seconds
echo "Running cpu switcher for xmrig proxy to update best coin to mine!"

curl -s http://pool-pay.com/api/pool > pool-pay.json
find=$(cat pool-pay.json | jq 'del(.lastpoolblocks)' | jq .[].ratio1 | sort | tail -n1)
echo "Found the best CPU coin to mine!"
###############
#Shows all data
#cat pool-pay.json | jq 'del(.lastpoolblocks)' | jq '.[] | select(.ratio1=='$find')'
###############
#Creates logfile
#cat pool-pay.json | jq 'del(.lastpoolblocks)' | jq -r '.[] | select(.ratio1=='$find').coin' >> cpu_hot.log
#cat pool-pay.json | jq 'del(.lastpoolblocks)' | jq -r '.[] | select(.ratio1=='$find').includealgo' >> cpu_hot.log
###############

coin=$(cat pool-pay.json | jq 'del(.lastpoolblocks)' | jq -r '.[] | select(.ratio1=='$find').coin')
algo=$(cat pool-pay.json | jq 'del(.lastpoolblocks)' | jq -r '.[] | select(.ratio1=='$find').includealgo')
pool=$(cat pool-pay.json | jq 'del(.lastpoolblocks)' | jq -r '.[] | select(.ratio1=='$find').pool')
port=$(cat pool-pay.json | jq 'del(.lastpoolblocks)' | jq -r '.[] | select(.ratio1=='$find').port')
symbol=$(cat pool-pay.json | jq 'del(.lastpoolblocks)' | jq -r '.[] | select(.ratio1=='$find').symbol')
pool=$(echo $pool:$port)
tls="false"
tlsfingerprint=null

#Wallets with custom pool examples and XMR fallback.

if [[ $symbol == "KVA" ]]; then
wallet="solo:xxx"
pool="pool.hashvault.pro:80"
tls="true"
tlsfingerprint="420c7850e09b7c0bdcf748a7da9eb3647daf8515718f36d9ccfdd6b9ff834b14"

elif [[ $symbol == "RTO" ]]; then
wallet="solo:xxx"
elif [[ $symbol == "DERO" ]]; then
wallet="xxx"
elif [[ $symbol == "SUMO" ]]; then
wallet="solo:xxx"
elif [[ $symbol == "AMX" ]]; then
wallet="solo:xxx"
else
algo="rx/0"
wallet=xxx
pool="gulf.moneroocean.stream:10128"
fi

pass=$(hostname)
current_coin=$(cat current_coin.log)

if [[ $current_coin != $symbol ]]; then

echo "Found $coin/$symbol, using $wallet, using $pool injecting now!"
sed -i '/"algo":.*/c\"algo": "'"$algo"'",' config.json
sed -i '/"url":.*/c\"url": "'"$pool"'",' config.json
sed -i '/"user":.*/c\"user": "'"$wallet"'",' config.json
sed -i '/"pass":.*/c\"pass": "'"$pass"'",' config.json
sed -i '/"tls":.*/c\"tls": '"$tls"',' config.json
sed -i '/"tls-fingerprint":.*/c\"tls-fingerprint": "'"${tlsfingerprint}"'",' config.json
echo $symbol > current_coin.log

else
        echo "Found same current symbol : $current_coin"
fi
