workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')

cd $ted_dir
make build
echo "finish generate makefile"
cd DOCKER
cp ../build/tendermint tendermint
docker build -t "registry-vpc.cn-beijing.aliyuncs.com/ruc500/shardingbc:latest" .
docker push registry-vpc.cn-beijing.aliyuncs.com/ruc500/shardingbc:latest
#echo "finish generate docker"
#docker save -o tendermint.tar tendermint1
#echo "finish save docker"
#docker rmi tendermint1
#echo "finish move docker"

