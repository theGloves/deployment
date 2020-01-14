ssh -i ~/.ssh/ruc_500_new centos@10.77.70.135 "sudo rm -r NFS500/network;mkdir NFS500/network"&
wait
echo -e "delete done: $SECONDS seconds"
scp -i ~/.ssh/ruc_500_new -r /home/linyihui/bushu/network centos@10.77.70.135:/home/centos/NFS500&

cp -r /home/linyihui/bushu/network /home/linyihui/go/src/github.com/tendermint/tendermint/&

wait
echo -e "send done:$SECONDS seconds"
