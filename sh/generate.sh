cd /home/linyihui/go/src/github.com/tendermint/tendermint
make install
echo "finish generate makefile"
cd DOCKER
cp /home/linyihui/go/bin/tendermint tendermint
docker build -t tendermint .
echo "finish generate docker"
docker save -o tendermint.tar tendermint 
echo "finish save docker"
#docker rmi tendermint
echo "finish move docker"

