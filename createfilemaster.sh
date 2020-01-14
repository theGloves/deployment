#!/bin/bash
node_cnt=$1
shard=("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T")
file_num=$2
rm -r network
rm -f /home/linyihui/bushu/topogensis.json
rm -f  /home/linyihui/bushu/shard.json
for (( j = 1; j <= $file_num; j++ ))
do
	
		count=$(($j-1))
		tmp=${shard[$count]} 
		echo $tmp
		./sh/init_data2.sh $node_cnt $count $file_num $tmp $j
		mkdir -p node${j}
		chmod 777 node${j}
		for (( i = 1; i <= $node_cnt; i++ )); do
		    mv node${i}_data TT${tmp}Node${i}
			cp TT${tmp}Node${i}/data/priv_validator_state.json TT${tmp}Node${i}/config/priv_validator_state.json 
		done
		cat docker-compose.yaml >> test.yaml
done
rm -rf docker-compose.yaml
sed -i "s/{version: 2}/version: 2/g" test.yaml
cat config/etcd.yaml >> test.yaml
sed -i "s/'true'/true/" test.yaml

mkdir /home/linyihui/bushu/network
chmod 777 /home/linyihui/bushu/network
for ((j=1;j<=$file_num;j++))
do	
	count=$(($j-1))
	tmp=${shard[$count]} 
	for (( i = 1; i <= $node_cnt; i++ )); 
	do
		mv  /home/linyihui/bushu/TT${tmp}Node${i} /home/linyihui/bushu/network
	done 

done

chmod 777 test.yaml
mv test.yaml network/docker-compose.yaml
cd /home/linyihui/go/src/github.com/tendermint/tendermint
rm -rf network
cd /home/linyihui/bushu
cp -r network /home/linyihui/go/src/github.com/tendermint/tendermint/
chmod -R 777 /home/linyihui/go/src/github.com/tendermint/tendermint/network
cd /home/linyihui/bushu
chmod 777 topogensis.json
mv topogensis.json /home/linyihui/bushu/network


python3 py/info.py
chmod 777 /home/linyihui/bushu/network/shard.json
chmod 777 /home/linyihui/bushu/network/data.json
mv /home/linyihui/bushu/network/shard.json /home/linyihui/bushu/config/
mv /home/linyihui/bushu/network/data.json  /home/linyihui/bushu/config/
