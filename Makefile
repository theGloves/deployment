build:
	bash sh/stage_quick_start.sh
	
install:
	pip install -y pyyaml
	pip install -y netwrokx


# 快速清除部署的应用
clean:
	# 根据label删除deployment&service
	./bin/kubectl delete -n tendermint services,deployments -l app=shardingbc
	curl -XPOST "http://127.0.0.1:9200/tendermint-20201007/_delete_by_query" -H 'Content-Type: application/json' -d'{  "query": {    "terms": {      "@log_name": ["tendermint.error","tendermint.tps","tendermint.latency"]    }  }}'

# 快速部署应用
quick:
	# 部署k8s服务&deployment
	bash sh/sendmasterfile.sh >/dev/null 2>&1
	./bin/kubectl create -n tendermint -f network/docker-compose.yaml 

test:
	bash batch_test.sh -n 4,8,16 -r 99999 -s 2 -t 200,400,600,800,1000 -i 60 -d 120
	sleep 120
	bash batch_test.sh -n 32,64 -r 99999 -s 2 -t 200,400,600,800,1000 -i 60 -d 150
