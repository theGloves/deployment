workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')
image=$(echo $(cat config/config.json | jq ".image")|sed 's/\"//g')

cd $ted_dir
make build
echo "finish generate makefile"
cd DOCKER
cp ../build/tendermint tendermint
docker build -t "${image}" .
docker push $image
echo "finish generate docker"
