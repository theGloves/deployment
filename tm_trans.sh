if [[ $1 > 0 ]]; then	
	cd /home/linyihui/go/src/github.com/tendermint/tendermint/tools/tm-bench
        make install
        cd /home/linyihui/go/bin
        chmod 777 tm-bench
        echo "make done____________________________________________________________________"
	scp -i ~/.ssh/ruc_500_new /home/linyihui/go/bin/tm-bench centos@10.77.70.142:/home/centos/lyh/tm-bench
	ssh -i ~/.ssh/ruc_500_new centos@10.77.70.142 "cd /home/centos/lyh;sudo docker cp tm-bench 4e5570ee8622:/dist"
else
	cd /home/linyihui/go/src/github.com/tendermint/tendermint/tools/tm-bench_noshard
        make install
        cd /home/linyihui/go/bin
        chmod 777 tm-bench_noshard
        echo "make done____________________________________________________________________"
	scp -i ~/.ssh/ruc_500_new /home/linyihui/go/bin/tm-bench_noshard centos@10.77.70.142:/home/centos/lyh/tm-bench_noshard
	ssh -i ~/.ssh/ruc_500_new centos@10.77.70.142 "cd /home/centos/lyh;sudo docker cp tm-bench_noshard 4e5570ee8622:/dist"
fi
