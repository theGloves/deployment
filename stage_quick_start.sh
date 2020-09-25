workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
./sh/generate.sh 
echo "generate docker.tar done"
./sh/trans2.sh 8 lyh
echo "trans tar to server done"
# ./sendmasterfile2.sh 
# echo "send newwork done"

