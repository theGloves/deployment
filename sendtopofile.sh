ssh -i ~/.ssh/ruc_500_new centos@10.77.70.135 "sudo rm -r NFS500/networktopo;mkdir NFS500/networktopo"&

wait
echo -e "delete done: $SECONDS seconds"
scp -i ~/.ssh/ruc_500_new -r /home/linyihui/bushu/networktopo centos@10.77.70.135:/home/centos/NFS500&

cp -r /home/linyihui/bushu/networktopo /home/linyihui/go/src/github.com/tendermint/tendermint/&

wait
echo -e "send done:$SECONDS seconds"
