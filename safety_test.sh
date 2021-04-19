# 参数 1. 分片数；2. 组数 [已经固定leader] 3. 怠工率 
TAG="test_data"
shard_str=$1
testdata=$2
abandon_str=$3
shard_list=${shard_str//,/ }
abandon_list=${abandon_str//,/ }

ted_dir=$(echo $(cat config/config.json | jq ".${TAG}.projectpwd")|sed 's/\"//g')
workdir=$(echo $(cat config/config.json | jq ".${TAG}.depolymentpwd")|sed 's/\"//g')
rm -rf log_analysis/testdata
mkdir log_analysis/testdata
for shard in $shard_list; do 
    # 节点批量生成
    bash createfilemaster.sh 20 ${shard}

    # 测试数据
    # 设置怠工率[发送带功率]
    for abandon in $abandon_list;
    do
        #启动分片
        make clean
        sleep 10
        make quick
        sleep 20
        # #开始测试
        echo "怠工率:"$abandon
        cd $ted_dir/tools/go-test
        ./strike 10.43.0.101:26657 relay1 $abandon # 对0分片设置怠工 接收怠工
        ./strike 10.43.0.101:26657 relay $abandon # 对0分片设置怠工 发送怠工
        cd $workdir 

        # # 测试6组
        sleep 30
        for i in $(seq 1 $testdata)
        do
            bash tm-simulator.sh $shard 200 50 20 2
            sleep 60
            echo ${i}" done."
        done
        
        echo "测试完成"
        # 分析数据
        datastr=''
        for ((i=0; i<${shard}; i++)) 
        do
            datastr=$datastr'tt'$i's1,'
        done
        datastr1=${datastr%*,}
        sleep 300 #等5分钟 让其能够发送完成
        ./log_analysis/grablogtime $datastr1 log_analysis/awk/time_awk log_analysis/testdata/TimeAnaShard${shard}Abandon${abandon}   
        # 删除数据 重新测试
        sleep 30
        make clean
    done

done