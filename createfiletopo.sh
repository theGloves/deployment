#!/bin/bash
node_cnt=$1
shard=("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T")
file_num=$2
rm -r networktopo
rm -f /home/linyihui/bushu/topogensis.json
rm -f  /home/linyihui/bushu/shard.json
for (( j = 1; j <= $file_num; j++ ))
do
	
		count=$(($j-1))
		tmp=${shard[$count]} 
		echo $tmp
		./sh/init_data3.sh $node_cnt $count $file_num $tmp $j
		mkdir -p node${j}
		chmod 777 node${j}
		for (( i = 1; i <= $node_cnt; i++ )); do
		    mv node${i}_data Topo${tmp}Node${i}
		done
		cat docker-compose.yaml >> test.yaml
done
rm -rf docker-compose.yaml
sed -i "s/{version: 2}/version: 2/g" test.yaml
sed -i "s/'true'/true/" test.yaml

mkdir /home/linyihui/bushu/networktopo
chmod 777 /home/linyihui/bushu/networktopo
for ((j=1;j<=$file_num;j++))
do	
	count=$(($j-1))
	tmp=${shard[$count]} 
	for (( i = 1; i <= $node_cnt; i++ )); 
	do
		mv  /home/linyihui/bushu/Topo${tmp}Node${i} /home/linyihui/bushu/networktopo
		#cp /home/linyihui/bushu/networktopo/Topo${tmp}Node${i}/data/priv_validator_state.json cp /home/linyihui/bushu/networktopo/Topo${tmp}Node${i}/config/priv_validator_state.json
	done 

done

chmod 777 test.yaml
mv test.yaml networktopo/docker-compose.yaml
cd /home/linyihui/go/src/github.com/tendermint/tendermint
rm -rf networktopo
cd /home/linyihui/bushu
cp -r networktopo /home/linyihui/go/src/github.com/tendermint/tendermint/
chmod -R 777 /home/linyihui/go/src/github.com/tendermint/tendermint/networktopo


for ((j=1;j<=$file_num;j++))
do	
	count=$(($j-1))
	tmp=${shard[$count]} 
	for (( i = 1; i <= $node_cnt; i++ )); 
	do
		cp /home/linyihui/bushu/config/shard.json  /home/linyihui/bushu/networktopo/Topo${tmp}Node${i}/config
		cp /home/linyihui/bushu/config/data.json  /home/linyihui/bushu/networktopo/Topo${tmp}Node${i}/config
		cp /home/linyihui/bushu/networktopo/Topo${tmp}Node${i}/data/priv_validator_state.json /home/linyihui/bushu/networktopo/Topo${tmp}Node${i}/config/priv_validator_state.json 
	done 

done  

rm -rf /home/linyihui/bushu/shard.json