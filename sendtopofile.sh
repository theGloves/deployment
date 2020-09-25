
workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".topopwd")|sed 's/\"//g')

# 清空es

for (( i=181; i<=196 ; i++ ))
do
	ssh -o StrictHostKeyChecking=no -i $workdir/key/weektest root@192.168.0.$i "sudo rm -rf NFS500/networktopo;mkdir NFS500/networktopo"&
done


#ssh -i $workdir/key/ruc_500_new centos@10.77.70.135 "sudo rm -r NFS500/network;mkdir NFS500/network"&

wait
echo -e "delete done: $SECONDS seconds"
for (( t=181;t<=196;t++ ))
do
	scp -o StrictHostKeyChecking=no -i $workdir/key/weektest -r $workdir/networktopo root@192.168.0.$t:/root/NFS500&
done
#scp -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.135:/home/centos/NFS500&


cp -r $workdir/networktopo$ted_dir/&

wait
echo -e "send done:$SECONDS seconds"
