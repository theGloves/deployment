workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')

#发送tenderminttopo文件到各个站点
scp -i $workdir/key/ruc_500_new $workdir/files/tendermint.tar centos@10.77.70.135:/home/centos/$2/tendermint.tar
echo "send done"
#各个站点删除镜像和载入镜像

ssh -i $workdir/key/ruc_500_new  centos@10.77.70.135  "cd /home/centos/$2;sudo docker load < tendermint.tar;sudo docker tag tendermint:latest 10.77.70.142:5000/tenderminttopo:v0.4;sudo docker push 10.77.70.142:5000/tenderminttopo:v0.4"

echo "load done"	
