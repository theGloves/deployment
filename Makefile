build:
	bash sh/stage_quick_start.sh
	
install:
	pip install -y pyyaml
	pip install -y netwrokx


# 快速清除部署的应用
clean:
	# 根据label删除deployment&service
	./bin/kubectl delete -n tendermint services,deployments -l app=shardingbc
	curl -XPOST "http://127.0.0.1:9200/localtest-20201026/_delete_by_query" -H 'Content-Type: application/json' -d'{  "query": {    "terms": {      "@log_name": ["tendermint.error","tendermint.tps","tendermint.latency"]    }  }}'

# 快速部署应用
quick:
	./bin/kubectl delete -n tendermint services,deployments -l app=shardingbc
	# 部署k8s服务&deployment
	bash sh/sendmasterfile.sh >/dev/null 2>&1
	./bin/kubectl create -n tendermint -f network/docker-compose.yaml 

test:
	bash sh/batch_test.sh -n 8 -r 2 -s 4,8,12 -t 100 -i 60 -d 60
	bash sh/batch_test.sh -n 8 -r 2 -s 4,8,12 -t 500 -i 60 -d 60
