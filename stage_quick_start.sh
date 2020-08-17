workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
./sh/generate.sh 
echo "generate docker.tar done"
./sendmasterfile.sh 
echo "send newwork done"

