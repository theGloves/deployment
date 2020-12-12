source ./sh/head.sh

# 清空es
#curl -XPOST "http://127.0.0.1:9200/localtest-20200921/_delete_by_query" -H 'Content-Type: application/json' -d'{  "query": {    "terms": {      "@log_name": ["tendermint.error","tendermint.tps","tendermint.latency"]    }  }}'

for (( i=135; i<=142 ; i++ ))
do
	ssh  -o StrictHostKeyChecking=no -i $workdir/key/ruc_500_new centos@10.77.70.$i "sudo rm -rf NFS500/network;sudo mkdir -p /home/centos/NFS500/network;sudo chmod 777 -R NFS500/network"&
	ssh  -o StrictHostKeyChecking=no -i $workdir/key/ruc_500_new centos@10.77.70.$[$i+28] "sudo rm -rf NFS500/network;sudo mkdir -p /home/centos/NFS500/network;sudo chmod 777 -R NFS500/network"&
done

wait
echo -e "delete done: $SECONDS seconds"

for (( t=135;t<=142;t++ ))
do
	sudo scp -o StrictHostKeyChecking=no -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.$t:/home/centos/NFS500&
	sudo scp -o StrictHostKeyChecking=no -i $workdir/key/ruc_500_new -r $workdir/network centos@10.77.70.$[t+28]:/home/centos/NFS500&
done

wait
echo -e "send done:$SECONDS seconds"
