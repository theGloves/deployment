source ./sh/head.sh

cd $ted_dir
make build
echo "finish generate makefile"
cd DOCKER
cp ../build/tendermint tendermint
sudo docker build -t "${image}" .
sudo docker push $image
echo "finish generate docker"
