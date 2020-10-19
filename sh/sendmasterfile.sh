workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')

# 清空es
#curl -XPOST "http://127.0.0.1:9200/localtest-20200921/_delete_by_query" -H 'Content-Type: application/json' -d'{  "query": {    "terms": {      "@log_name": ["tendermint.error","tendermint.tps","tendermint.latency"]    }  }}'

for (( i=181; i<=196 ; i++ ))
do
	ssh -o StrictHostKeyChecking=no -i $workdir/key/weektest root@192.168.0.$i "sudo rm -rf NFS500/network;mkdir NFS500/network"&
done

wait
echo -e "delete done: $SECONDS seconds"

for (( t=181;t<=196;t++ ))
do
	scp -o StrictHostKeyChecking=no -i $workdir/key/weektest -r $workdir/network root@192.168.0.$t:/root/NFS500&
done

wait
echo -e "send done:$SECONDS seconds"