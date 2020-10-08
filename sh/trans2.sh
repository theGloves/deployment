workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')


# 到每个服务器上依次拉取镜像
for (( i=181; i <= 196 ; i++ ))
do
	ssh  -o StrictHostKeyChecking=no -i $workdir/key/weektest root@192.168.0.$i "docker login --username=yusfko -p Yu@sf0110 registry-vpc.cn-beijing.aliyuncs.com;docker pull registry-vpc.cn-beijing.aliyuncs.com/ruc500/shardingbc:latest"&
	# ssh  -o StrictHostKeyChecking=no -i $workdir/key/weektest root@192.168.0.$i "docker login --username=yusfko -p Yu@sf0110 registry-vpc.cn-beijing.aliyuncs.com;docker pull registry-vpc.cn-beijing.aliyuncs.com/ruc500/tendermint:0.31"&
	# ssh  -o StrictHostKeyChecking=no -i $workdir/key/weektest root@192.168.0.$i "echo 3 > /proc/sys/vm/drop_caches"&
done

#cp $ted_dir/DOCKER/tendermint.tar $workdir/files/tendermint.tar
#rm -f $ted_dir/DOCKER/tendermint.tar
#cd $workdir;
#./sh/trans.sh $1 $2
