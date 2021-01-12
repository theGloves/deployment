#!/bin/bash
source ./sh/head.sh

node_cnt=$1
file_num=$2
no_cache=1

# 在cache中检查是否有生成好的配置文件
# cache_name编码格式
# cut 删除输出hash值后面的‘-’小尾巴·
cache_name=$(echo -n "${file_num}_${node_cnt}_${image}" | md5sum | cut -d" " -f1)

# 清空环境
rmConfig() {
	rm -r $workdir/network
	rm -f $workdir/topogensis.json
	rm -f $workdir/shard.json
}

# 从cache中加载配置
loadCache() {
	cp -R ./cache/${cache_name} ./network
}


createConfig() {
	for ((j = 1; j <= $file_num; j++)); do
		count=$(($j - 1))
		echo $count
		# 生成tendermint配置文件
		bash ./sh/init_master_data.sh $node_cnt $count $file_num $count $j
		mkdir -p node${j}
		chmod 777 node${j}
		for ((i = 1; i <= $node_cnt; i++)); do
			mv node${i}_data tt${count}s${i}
			cp tt${count}s${i}/data/priv_validator_state.json tt${count}s${i}/config/priv_validator_state.json
		done
		cat docker-compose.yaml >>test.yaml
	done

	rm -rf docker-compose.yaml

	mkdir $workdir/network
	sudo chmod 777 $workdir/network
	for ((j = 1; j <= $file_num; j++)); do
		count=$(($j - 1))
		for ((i = 1; i <= $node_cnt; i++)); do
			mv $workdir/tt${count}s${i} $workdir/network
		done
	done

	sudo chmod 777 test.yaml
	mv test.yaml network/docker-compose.yaml
	cd $workdir
	sudo chmod 777 topogensis.json
	mv topogensis.json $workdir/network

	python3 py/info.py
	sudo chmod 777 $workdir/network/shard.json
	sudo chmod 777 $workdir/network/data.json
	sudo chmod 777 -R $workdir/network/
	mv /$workdir/network/shard.json $workdir/config/
	mv $workdir/network/data.json $workdir/config/

	sudo rm -rf node[0-9]*
	sudo rm -rf [0-9]+S[0-9]+

	# 将此次生成的配置添加到cache中

	cp -R network cache/${cache_name}
}


# 如果允许从cache中加载且存在的话
rmConfig
if [ $no_cache -eq 0 -a -d "./cache/${cache_name}" ]; then
	echo $cache_name
	cp -R ./cache/${cache_name} ./network
	exit
fi

createConfig
