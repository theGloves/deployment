workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".topopwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')

cd $ted_dir
make install
echo "finish generate makefile"
cd DOCKER
cp $ted_bin/tendermint tendermint
docker build -t "registry-vpc.cn-beijing.aliyuncs.com/ruc500/reconfiguration:latest" .
docker push registry-vpc.cn-beijing.aliyuncs.com/ruc500/reconfiguration:latest
