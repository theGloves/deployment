# 一组实验10s 跑20组
for i in $(seq 1 20)
do
	bash tm-simulator.sh 14 100 10 8 2
	tail -n 1 tps/tps.log >> tps/lyh.log
done

