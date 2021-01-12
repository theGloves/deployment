source ./sh/head.sh
cd $workdir

sudo rm -rf sum.log
cmd=$(python3 py/bench.py $1 $2 $3 $4 $5)
echo "开始测试"

echo $cmd
sudo docker exec -i $container_id bash -c "$cmd" >> sum.log

# tps=$(python3 py/calculate_monitor.py $1 $5)
# total=$[$1*$2]
# shardtotal=$[$1*$4]
# echo $1 $shardtotal $total $5 $tps >> tps/tps.log
