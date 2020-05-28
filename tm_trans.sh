workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')

if [[ $1 > 0 ]]; then	
	cd $ted_dir/tools/tm-bench
        make install
        cd $ted_bin
        chmod 777 tm-bench
        echo "make done____________________________________________________________________"
	scp -i $workdir/key/ruc_500_new $ted_bin/tm-bench centos@10.77.70.142:/home/centos/lyh
	ssh -i $workdir/key/ruc_500_new centos@10.77.70.142 "cd /home/centos/lyh;sudo docker cp tm-bench 79a2c8eb2263:/dist"
else
	cd $ted_dir/tools/tm-bench_noshard
        make install
        cd $ted_bin
        chmod 777 tm-bench_noshard
        echo "make done____________________________________________________________________"
	scp -i $workdir/key/ruc_500_new $ted_bin/tm-bench_noshard centos@10.77.70.142:/home/centos/lyh/tm-bench_noshard
	ssh -i $workdir/key/ruc_500_new centos@10.77.70.142 "cd /home/centos/lyh;sudo docker cp tm-bench_noshard 79a2c8eb2263:/dist"
fi
