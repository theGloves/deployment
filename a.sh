s=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
rm -r $s/network
