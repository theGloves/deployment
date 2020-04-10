#!/bin/bash
node_cnt=$1
workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".topopwd")|sed 's/\"//g')
shard=("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T")
file_num=$2
cd $workdir
rm -r networktopo
rm -f $workdir/topogensis.json
rm -f  $workdir/shard.json
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

mkdir $workdir/networktopo
chmod 777 $workdir/networktopo
for ((j=1;j<=$file_num;j++))
do	
	count=$(($j-1))
	tmp=${shard[$count]} 
	for (( i = 1; i <= $node_cnt; i++ )); 
	do
		mv  $workdir/Topo${tmp}Node${i} $workdir/networktopo
		#cp $workdir/networktopo/Topo${tmp}Node${i}/data/priv_validator_state.json cp $workdir/networktopo/Topo${tmp}Node${i}/config/priv_validator_state.json
	done 

done

chmod 777 test.yaml
mv test.yaml networktopo/docker-compose.yaml
cd $ted_dir
rm -rf networktopo
cd $workdir
cp -r networktopo $ted_dir/
chmod -R 777 $ted_dir/networktopo


for ((j=1;j<=$file_num;j++))
do	
	count=$(($j-1))
	tmp=${shard[$count]} 
	for (( i = 1; i <= $node_cnt; i++ )); 
	do
		cp $workdir/config/shard.json  $workdir/networktopo/Topo${tmp}Node${i}/config
		cp $workdir/config/data.json  $workdir/networktopo/Topo${tmp}Node${i}/config
		cp $workdir/networktopo/Topo${tmp}Node${i}/data/priv_validator_state.json $workdir/networktopo/Topo${tmp}Node${i}/config/priv_validator_state.json 
	done 

done  

rm -rf $workdir/shard.json