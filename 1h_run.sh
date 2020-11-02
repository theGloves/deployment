
# 一组实验2分钟 跑20组
for i in $(seq 1 20)
do
	bash tm-simulator.sh 10 100 120 8 2
	sleep 60
	echo ${i}" done."
done

