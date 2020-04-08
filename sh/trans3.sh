workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')

cp $ted_dir/DOCKER/tendermint.tar $workdir/files/tendermint.tar
rm -f $ted_dir/DOCKER/tendermint.tar
cd $workdir
./sh/trans11.sh $1 $2
