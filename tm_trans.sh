workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
bench_dir=$(echo $(cat config/config.json | jq ".benchpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')
home_pwd=$(echo $(cat config/config.json | jq ".Home")|sed 's/\"//g')
container_id=$(echo $(cat config/config.json | jq ".containerid")|sed 's/\"//g')
if [[ $1 > 0 ]]; then	
	cd $ted_dir/tools/tm-bench
        make install
        cd $ted_bin
        echo "make done____________________________________________________________________"
        cd $ted_bin;docker cp tm-bench $container_id:/dist
else
	cd $bench_dir/tools/tm-bench
        make install
        cd $ted_bin
        echo "make done____________________________________________________________________"
        scp -i $workdir/key/weektest tm-bench root@192.168.0.190:~/lyh
        ssh -i $workdir/key/weektest root@192.168.0.190 "cd lyh;docker cp tm-bench $container_id:/dist/tm-bench_simulator"
fi
