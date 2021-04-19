# 参数 1. 分片数；2. 组数 [已经固定leader]
shard_str=$1
testdata=$2
shard_list=${shard_str//,/ }
rm -rf log_analysis/testdata
mkdir log_analysis/testdata
for shard in $shard_list; do 
    # 节点批量生成
    bash createfilemaster.sh 16 ${shard}
    make clean
    sleep 30
    make quick
    # 测试数据
    sleep 30
    for i in $(seq 1 $testdata)
    do
        bash tm-simulator.sh $shard 200 50 16 2
        sleep 130
        echo ${i}" done."
    done
    # 分析数据
    datastr=''
    for ((i=0; i<${shard}; i++)) do
        datastr=$datastr'tt'$i's1,'
    done
    datastr1=${datastr%*,}
    ./log_analysis/grablogtime $datastr1 log_analysis/awk/time_awk log_analysis/testdata/TimeAnaShard${shard}
    ./log_analysis/grablogconsensus $datastr1 log_analysis/awk/consensus_awk log_analysis/testdata/ConsensusAnaShard${shard}.csv       
 
    sleep 30
    make clean
done