echo $1
# 清空es
# curl -XPOST "http://127.0.0.1:9200/localtest-20200920/_delete_by_query" -H 'Content-Type: application/json' -d'{  "query": {    "terms": {      "@log_name": ["tendermint.latency"]    }  }}'
echo '\n'
# 200
time=$(date "+%Y-%m-%d %H:%M:%S")
echo "${time}"
bash tm-simulator.sh 1 200 60 $1 999999

# 400
sleep 90
time=$(date "+%Y-%m-%d %H:%M:%S")
echo "${time}"
bash tm-simulator.sh 1 400 60 $1 999999

# 600
sleep 90
time=$(date "+%Y-%m-%d %H:%M:%S")
echo "${time}"
bash tm-simulator.sh 1 600 60 $1 999999

# 800
sleep 90
time=$(date "+%Y-%m-%d %H:%M:%S")
echo "${time}"
bash tm-simulator.sh 1 800 60 $1 999999

# 1000
sleep 90
time=$(date "+%Y-%m-%d %H:%M:%S")
echo "${time}"
bash tm-simulator.sh 1 1000 60 $1 999999
