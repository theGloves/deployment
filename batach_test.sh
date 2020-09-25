#! /bin/bash

# 样例 使用eth数据，测试单片8、16、32、64节点 发送速率200、400、600、800、1000
# bash batach_test.sh -E -n 8,16,32,64 -s 1 -t 200,400,600,800,1000

NODE_NUM="8,16,32"            #n
SHARD_NUM="1,2,4"             #s
TX_NUM="200,400,600,800"      #t
TEST_DURATION=60              #d
TEST_INTERVAL=60              #i
IS_DRAW=0                     #D
CROSS_RATE=2                  #r
NO_RECONFIG=0                 #R
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
      bash sendmasterfile2.sh >/dev/null 2>&1
      python py/autorancher.py
      sleep 120
      for tx in $TX_NUM; do
        sleep $TEST_INTERVAL
        echo "========== ${shard} ${node} ${tx} test begin =========="
        txtmp=$(expr $(($tx / $shard)))
        if [ $shard = '1' ]; then
          cr_tmp=99999
        else
          cr_tmp=${CROSS_RATE}
        fi
        bash ${TEST_SCRIPT} ${shard} ${tx} ${TEST_DURATION} ${node} ${cr_tmp}

        # 打印结果 分片数 片内节点数 发送速率 TPS
        echo "${shard} ${node} ${tx} $(tail -n 1 tps/tps.log | awk '{ print $5 }')" >>batch.log
        echo "${shard} ${node} ${tx} $(tail -n 1 tps/tps.log | awk '{ print $5 }')"
        echo "========== ${shard} ${node} test done =========="

      done
    done
  done
}

# 解析参数
while getopts ":n:s:t:d:i:Dr:NE" opt; do
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
  d)
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
