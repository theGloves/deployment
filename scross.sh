echo $1
# 清空es
# curl -XPOST "http://127.0.0.1:9200/localtest-20200920/_delete_by_query" -H 'Content-Type: application/json' -d'{  "query": {    "terms": {      "@log_name": ["tendermint.latency"]    }  }}'
echo '\n'
# 200
time=$(date "+%Y-%m-%d %H:%M:%S")
echo "${time}"
bash tm-simulator.sh 10 20 60 $1 2

# 400
sleep 90
time=$(date "+%Y-%m-%d %H:%M:%S")
echo "${time}"
bash tm-simulator.sh 10 40 60 $1 2

# 600
sleep 90
time=$(date "+%Y-%m-%d %H:%M:%S")
echo "${time}"
bash tm-simulator.sh 10 60 60 $1 2

# 800
sleep 90
time=$(date "+%Y-%m-%d %H:%M:%S")
echo "${time}"
bash tm-simulator.sh 10 80 60 $1 2

# 1000
sleep 90
time=$(date "+%Y-%m-%d %H:%M:%S")
echo "${time}"
bash tm-simulator.sh 10 100 60 $1 2

# 1500
sleep 90
time=$(date "+%Y-%m-%d %H:%M:%S")
echo "${time}"
bash tm-simulator.sh 10 188 60 $1 2

# 2000
sleep 90
time=$(date "+%Y-%m-%d %H:%M:%S")
echo "${time}"
bash tm-simulator.sh 10 200 60 $1 2