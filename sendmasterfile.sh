workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ssh -i $workdir/key/ruc_500_new centos@10.77.70.135 "sudo rm -r NFS500/network;mkdir NFS500/network"&
wait
echo -e "delete done: $SECONDS seconds"
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.135:/home/centos/NFS500&

cp -r $workdir/network $ted_dir/&

wait
echo -e "send done:$SECONDS seconds"
