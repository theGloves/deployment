workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".topopwd")|sed 's/\"//g')
./sh/generatetopo.sh 
echo "generate docker.tar done"
./sh/trans3.sh 8 lyh
echo "trans tar to server done"
./sendtopofile.sh 
echo "send newwork done"

