build:
	bash sh/stage_quick_start.sh
	
install:
	pip install -y pyyaml
	pip install -y netwrokx


# 快速清除部署的应用
clean:
	# 根据label删除deployment&service
	./bin/kubectl delete -n tendermint services,deployments -l app=shardingbc
	curl -XPOST "http://127.0.0.1:9200/localtest-20201109/_delete_by_query" -H 'Content-Type: application/json' -d'{  "query": {    "terms": {      "@log_name": ["tendermint.error","tendermint.tps","tendermint.latency"]    }  }}'

# 快速部署应用
quick:
	./bin/kubectl delete -n tendermint services,deployments -l app=shardingbc
	# 部署k8s服务&deployment
	bash sh/sendmasterfile.sh >/dev/null 2>&1
	./bin/kubectl create -n tendermint -f network/docker-compose.yaml 

test:
	bash sh/batch_test.sh -n 8 -r 9999999 -s 1,2,4,6,8,10 -t 1200 -i 60 -d 60
