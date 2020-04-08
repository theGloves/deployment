sudo rm -rf sum.log
cmd=$(python py/test.py $1 $2 $3 $4 $5)
echo $cmd
ssh -i ~/.ssh/ruc_500_new centos@10.77.70.142 $cmd >> sum.log
tps=$(python py/calculate.py $1 $5)
echo $1 $4 $2 $tps >> tps/tps.log

