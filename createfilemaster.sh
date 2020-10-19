#!/bin/bash
node_cnt=$1
workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
file_num=$2

rm -r $workdir/network
rm -f $workdir/topogensis.json
rm -f $workdir/shard.json

for (( j = 1; j <= $file_num; j++ ))
do
		count=$(($j-1))
		echo $count
		# 生成tendermint配置文件
		./sh/init_master_data.sh $node_cnt $count $file_num $count $j
		mkdir -p node${j}
		chmod 777 node${j}
		for (( i = 1; i <= $node_cnt; i++ )); do
		    mv node${i}_data ${count}S${i}
			cp ${count}S${i}/data/priv_validator_state.json ${count}S${i}/config/priv_validator_state.json 
		done
		cat docker-compose.yaml >> test.yaml
done

rm -rf docker-compose.yaml
sed -i "s/{version: 2}/version: 2/g" test.yaml
cat config/net.yaml >> test.yaml
sed -i "s/'true'/true/" test.yaml

mkdir $workdir/network
chmod 777 $workdir/network
for ((j=1;j<=$file_num;j++))
do	
	count=$(($j-1))
	for (( i = 1; i <= $node_cnt; i++ )); 
	do
		mv $workdir/${count}S${i} $workdir/network
	done 

done

chmod 777 test.yaml
mv test.yaml network/docker-compose.yaml
cd $workdir
chmod 777 topogensis.json
mv topogensis.json $workdir/network

python3 py/info.py
chmod 777 $workdir/network/shard.json
chmod 777 $workdir/network/data.json
chmod 777 -R $workdir/network/
mv /$workdir/network/shard.json $workdir/config/
mv $workdir/network/data.json  $workdir/config/
