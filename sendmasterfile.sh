workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
data=$(echo $(cat config/config.json | jq ".Data")|sed 's/\"//g')
ssh -i $workdir/key/ruc_500_new centos@10.77.70.135 "sudo rm -r NFS500/network;mkdir NFS500/network"&
rm -r $data/network
mkdir $data/network
wait
echo -e "delete done: $SECONDS seconds"
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.135:/home/centos/NFS500/network&

cp -r $workdir/network $ted_dir/&

cp -r $workdir/network $data/&
chmod 777 -R $data/network
wait
echo -e "send done:$SECONDS seconds"
