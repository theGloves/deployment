
build:
	bash stage_quick_start.sh
	
# 快速清除部署的应用
clean:
	python py/autorancher.py clean
	curl -XPOST "http://127.0.0.1:9200/tendermint-20201007/_delete_by_query" -H 'Content-Type: application/json' -d'{  "query": {    "terms": {      "@log_name": ["tendermint.error","tendermint.tps","tendermint.latency"]    }  }}'

# 快速部署应用
quick:
	python py/autorancher.py clean
	bash sendmasterfile2.sh
	python py/autorancher.py

test:
	bash batch_test.sh -n 4,8,16 -r 99999 -s 2 -t 200,400,600,800,1000 -i 60 -d 120
	sleep 120
	bash batch_test.sh -n 32,64 -r 99999 -s 2 -t 200,400,600,800,1000 -i 60 -d 150

