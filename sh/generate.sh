workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')
docker rmi tendermint:latest
cd $ted_dir
make install
echo "finish generate makefile"
cd $ted_bin
cp tendermint $ted_dir/DOCKER/tendermint
cd $ted_dir
cd DOCKER

docker build -t tendermint .
echo "finish generate docker"

rm -rf tendermint
echo "finish move docker"
