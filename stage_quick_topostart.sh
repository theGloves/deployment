workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
cd $workdir
./sh/generate.sh 
cd $workdir
echo "generate docker.tar done"
./sh/trans3.sh 8 lyh
echo "trans tar to server done"
cd $workdir
./sendtopofile.sh
echo "send newwork done"
cd $workdir
