cp /home/linyihui/go/src/github.com/tendermint/tendermint/DOCKER/tendermint.tar /home/linyihui/tendermint/tendermint.tar
rm -f /home/linyihui/go/src/github.com/tendermint/tendermint/DOCKER/tendermint.tar
cd /home/linyihui/tendermint;
./trans2.sh $1 $2
