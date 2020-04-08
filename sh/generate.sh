workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')

cd $ted_dir
make install
echo "finish generate makefile"
cd DOCKER
cp $ted_bin/tendermint tendermint
docker build -t tendermint .
echo "finish generate docker"
docker save -o tendermint.tar tendermint 
echo "finish save docker"
#docker rmi tendermint
echo "finish move docker"

