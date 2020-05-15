workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')

cd $ted_dir
make install
echo "finish generate makefile"
cd $ted_bin
cp tendermint $ted_dir/DOCKER/tendermint
cd $ted_dir
cd DOCKER

docker build -t tendermint1 .
echo "finish generate docker"
docker save -o tendermint.tar tendermint1
echo "finish save docker"
docker rmi tendermint1
echo "finish move docker"
rm -rf tendermint

