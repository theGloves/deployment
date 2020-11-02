#! /bin/bash
# 样例 使用eth数据，测试单片8、16、32、64节点 发送速率200、400、600、800、1000
# bash batach_test.sh -E -n 8,16,32,64 -s 1 -t 200,400,600,800,1000

NODE_NUM="8,16,32"            #n 片内节点数
SHARD_NUM="1,2,4"             #s 测试分片数
TX_NUM="200,400,600,800"      #t 每秒发送速率
TEST_DURATION=60              #d 测试持续时间
TEST_INTERVAL=60              #i 两次测试间隔、rancher部署后冷却时间
IS_DRAW=0                     #D 是否画图 TODO
CROSS_RATE=2                  #r 跨片率
NO_RECONFIG=0                 #R 不用重新生成配置文件 DEBUG
TEST_SCRIPT="tm-simulator.sh" #E 使用eth数据

main() {
  NODE_NUM=${NODE_NUM//,/ }
  SHARD_NUM=${SHARD_NUM//,/ }
  TX_NUM=${TX_NUM//,/ }

  # 从shard开始循环
  for shard in $SHARD_NUM; do
    for node in $NODE_NUM; do
      # 只创建一次配置文件
      if [ ${NO_RECONFIG} -eq 0 ]; then
        bash createfilemaster.sh ${node} ${shard} >/dev/null 2>&1
      fi
      ./bin/kubectl delete -n tendermint services,deployments -l app=shardingbc
      bash sh/sendmasterfile.sh >/dev/null 2>&1
  	  #curl -XPOST "http://127.0.0.1:9200/tendermint-20201007/_delete_by_query" -H 'Content-Type: application/json' -d'{  "query": {    "terms": {      "@log_name": ["tendermint.error","tendermint.tps","tendermint.latency"]    }  }}'
	  ./bin/kubectl create -n tendermint -f network/docker-compose.yaml 
#      sleep $TEST_INTERVAL
      for tx in $TX_NUM; do
        sleep $TEST_INTERVAL
        echo "========== ${shard} ${node} ${tx} test begin =========="
        txtmp=$(expr $(($tx / $shard)))
        if [ $shard = '1' ]; then
          cr_tmp=99999
        else
          cr_tmp=${CROSS_RATE}
        fi
        rm -rf /home/centos/theGloves/workspace/EFK/fluentd/data/latency.*
        bash ${TEST_SCRIPT} ${shard} ${tx} ${TEST_DURATION} ${node} ${cr_tmp}
        # 打印结果 分片数 片内节点数 发送速率 TPS
        echo "${shard} ${node} ${tx} $(tail -n 1 tps/tps.log | awk '{ print $5 }')" >> tps/batch.log
        echo "${shard} ${node} ${tx} $(tail -n 1 tps/tps.log | awk '{ print $5 }')"

        # 等待日志落盘
        sleep 61
        # 日志转储 后续分析
        mkdir /home/centos/theGloves/workspace/EFK/fluentd/data/${shard}_${node}_${tx}
        mv /home/centos/theGloves/workspace/EFK/fluentd/data/latency.* /home/centos/theGloves/workspace/EFK/fluentd/data/${shard}_${node}_${tx}
  		echo "========== ${shard} ${node} test done =========="
      done
    done

    # 删除部署的应用
  	./bin/kubectl delete -n tendermint services,deployments -l app=shardingbc
  done
}

# 解析参数
while getopts ":n:s:t:d:i:Dr:NER" opt; do
  case $opt in
  n)
    NODE_NUM=$OPTARG
    ;;
  s)
    SHARD_NUM=$OPTARG
    ;;
  t)
    TX_NUM=$OPTARG
    ;;
  d)
    TEST_DURATION=$OPTARG
    ;;
  i)
    TEST_INTERVAL=$OPTARG
    ;;
  D)
    IS_DRAW=1
    ;;
  r)
    CROSS_RATE=$OPTARG
    ;;
  R)
    NO_RECONFIG=1
    ;;
  E)
    TEST_SCRIPT="tm-test.sh"
    ;;
  \?)
    echo "Invalid option: -$OPTARG"
    ;;
  esac
done

main
