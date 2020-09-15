workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')
home_pwd=$(echo $(cat config/config.json | jq ".Home")|sed 's/\"//g')
container_id=$(echo $(cat config/config.json | jq ".containerid")|sed 's/\"//g')
if [[ $1 > 0 ]]; then	
	cd $ted_dir/tools/tm-bench
        make install
        cd $ted_bin
        chmod 777 tm-bench
        echo "make done____________________________________________________________________"
	cp  $ted_bin/tm-bench $home_pwd/lyh;
        cd $home_pwd/lyh;
        sudo docker cp tm-bench $container_id:/dist
else
	cd $ted_dir/tools/tm-bench_noshard
        make install
        cd $ted_bin
        chmod 777 tm-bench_noshard
        echo "make done____________________________________________________________________"
	scp  $ted_bin/tm-bench_noshard /root/lyh/tm-bench_noshard
        cd $home_pwd/lyh;sudo docker cp tm-bench_noshard $container_id:/dist
fi
