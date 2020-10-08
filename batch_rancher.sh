workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')

index=1
# 到每个服务器上依次拉取镜像
for (( i=181; i <= 196 ; i++ ))
do
	if [ $i -eq 190 ] 
	then
		continue
	fi
	ssh  -o StrictHostKeyChecking=no -i $workdir/key/weektest root@192.168.0.$i "sudo docker run -e CATTLE_HOST_LABELS='label="${index}"'  --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.11 http://192.168.0.190:8080/v1/scripts/ECEF6904FCDC8DA2180F:1577750400000:HYwHtprs15ghGDWYwU6y9lFWag"&

	index=$(( $index + 1 ))
	
done

#cp $ted_dir/DOCKER/tendermint.tar $workdir/files/tendermint.tar
#rm -f $ted_dir/DOCKER/tendermint.tar
#cd $workdir;
#./sh/trans.sh $1 $2
