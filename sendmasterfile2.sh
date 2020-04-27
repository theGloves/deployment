workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ssh -i $workdir/key/ruc_500_new centos@10.77.70.135 "sudo rm -r NFS500/network;mkdir NFS500/network"&
ssh -i $workdir/key/ruc_500_new centos@10.77.70.136 "sudo rm -r NFS500/network;mkdir NFS500/network"&
ssh -i $workdir/key/ruc_500_new centos@10.77.70.137 "sudo rm -r NFS500/network;mkdir NFS500/network"&
ssh -i $workdir/key/ruc_500_new centos@10.77.70.138 "sudo rm -r NFS500/network;mkdir NFS500/network"&
ssh -i $workdir/key/ruc_500_new centos@10.77.70.139 "sudo rm -r NFS500/network;mkdir NFS500/network"&
ssh -i $workdir/key/ruc_500_new centos@10.77.70.140 "sudo rm -r NFS500/network;mkdir NFS500/network"&
ssh -i $workdir/key/ruc_500_new centos@10.77.70.164 "sudo rm -r NFS500/network;mkdir NFS500/network"&
ssh -i $workdir/key/ruc_500_new centos@10.77.70.165 "sudo rm -r NFS500/network;mkdir NFS500/network"&
ssh -i $workdir/key/ruc_500_new centos@10.77.70.166 "sudo rm -r NFS500/network;mkdir NFS500/network"&
ssh -i $workdir/key/ruc_500_new centos@10.77.70.167 "sudo rm -r NFS500/network;mkdir NFS500/network"&
ssh -i $workdir/key/ruc_500_new centos@10.77.70.168 "sudo rm -r NFS500/network;mkdir NFS500/network"&
ssh -i $workdir/key/ruc_500_new centos@10.77.70.169 "sudo rm -r NFS500/network;mkdir NFS500/network"&
ssh -i $workdir/key/ruc_500_new centos@10.77.70.170 "sudo rm -r NFS500/network;mkdir NFS500/network"&
ssh -i $workdir/key/ruc_500_new centos@10.77.70.163 "sudo rm -r NFS500/network;mkdir NFS500/network"&
ssh -i $workdir/key/ruc_500_new centos@10.77.70.141 "sudo rm -r NFS500/network;mkdir NFS500/network"&

wait
echo -e "delete done: $SECONDS seconds"
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.135:/home/centos/NFS500&
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.136:/home/centos/NFS500&
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.137:/home/centos/NFS500&
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.138:/home/centos/NFS500&
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.139:/home/centos/NFS500&
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.140:/home/centos/NFS500&
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.141:/home/centos/NFS500&
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.163:/home/centos/NFS500&
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.164:/home/centos/NFS500&
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.165:/home/centos/NFS500&
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.166:/home/centos/NFS500&
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.167:/home/centos/NFS500&
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.168:/home/centos/NFS500&
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.169:/home/centos/NFS500&
scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.170:/home/centos/NFS500&




cp -r $workdir/network $ted_dir/&

wait
echo -e "send done:$SECONDS seconds"
