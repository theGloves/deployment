workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')

cd $workdir

sudo rm -rf sum.log
cmd=$(python3 py/test.py $1 $2 $3 $4 $5)
echo $cmd
ssh -i $workdir/key/ruc_500_new centos@10.77.70.142 $cmd >> sum.log
tps=$(python3 py/calculate.py $1 $5)
echo $1 $4 $2 $tps >> tps/tps.log

