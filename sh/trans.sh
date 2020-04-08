workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')

#发送tendermint文件到各个站点
scp -i $workdir/key/ruc_500_new $workdir/files/tendermint.tar centos@10.77.70.135:/home/centos/$2/tendermint.tar
echo "send done"
#各个站点删除镜像和载入镜像

ssh -i $workdir/key/ruc_500_new  centos@10.77.70.135  "cd /home/centos/$2;sudo docker load < tendermint.tar;sudo docker tag tendermint:latest 10.77.70.142:5000/tendermint:v0.4;sudo docker push 10.77.70.142:5000/tendermint:v0.4"

echo "load done"	

ssh -i $workdir/key/ruc_500_new  centos@10.77.70.136 "sudo docker rmi 10.77.70.142:5000/tendermint:v0.4;sudo docker pull 10.77.70.142:5000/tendermint:v0.4"&
ssh -i $workdir/key/ruc_500_new  centos@10.77.70.137 "sudo docker rmi 10.77.70.142:5000/tendermint:v0.4;sudo docker pull 10.77.70.142:5000/tendermint:v0.4"&
ssh -i $workdir/key/ruc_500_new  centos@10.77.70.138 "sudo docker rmi 10.77.70.142:5000/tendermint:v0.4;sudo docker pull 10.77.70.142:5000/tendermint:v0.4"&
ssh -i $workdir/key/ruc_500_new  centos@10.77.70.139 "sudo docker rmi 10.77.70.142:5000/tendermint:v0.4;sudo docker pull 10.77.70.142:5000/tendermint:v0.4"&
ssh -i $workdir/key/ruc_500_new  centos@10.77.70.140 "sudo docker rmi 10.77.70.142:5000/tendermint:v0.4;sudo docker pull 10.77.70.142:5000/tendermint:v0.4"&
ssh -i $workdir/key/ruc_500_new  centos@10.77.70.141 "sudo docker rmi 10.77.70.142:5000/tendermint:v0.4;sudo docker pull 10.77.70.142:5000/tendermint:v0.4"&
ssh -i $workdir/key/ruc_500_new  centos@10.77.70.163 "sudo docker rmi 10.77.70.142:5000/tendermint:v0.4;sudo docker pull 10.77.70.142:5000/tendermint:v0.4"&
ssh -i $workdir/key/ruc_500_new  centos@10.77.70.164 "sudo docker rmi 10.77.70.142:5000/tendermint:v0.4;sudo docker pull 10.77.70.142:5000/tendermint:v0.4"&
ssh -i $workdir/key/ruc_500_new  centos@10.77.70.165 "sudo docker rmi 10.77.70.142:5000/tendermint:v0.4;sudo docker pull 10.77.70.142:5000/tendermint:v0.4"&
ssh -i $workdir/key/ruc_500_new  centos@10.77.70.166 "sudo docker rmi 10.77.70.142:5000/tendermint:v0.4;sudo docker pull 10.77.70.142:5000/tendermint:v0.4"&
ssh -i $workdir/key/ruc_500_new  centos@10.77.70.167 "sudo docker rmi 10.77.70.142:5000/tendermint:v0.4;sudo docker pull 10.77.70.142:5000/tendermint:v0.4"&
ssh -i $workdir/key/ruc_500_new  centos@10.77.70.168 "sudo docker rmi 10.77.70.142:5000/tendermint:v0.4;sudo docker pull 10.77.70.142:5000/tendermint:v0.4"&
ssh -i $workdir/key/ruc_500_new  centos@10.77.70.169 "sudo docker rmi 10.77.70.142:5000/tendermint:v0.4;sudo docker pull 10.77.70.142:5000/tendermint:v0.4"&
ssh -i $workdir/key/ruc_500_new  centos@10.77.70.170 "sudo docker rmi 10.77.70.142:5000/tendermint:v0.4;sudo docker pull 10.77.70.142:5000/tendermint:v0.4"&
wait
#启动docker镜像'ssh -i $workdir/key/id_rsa_768 centos@10.77.50.22 -p 10006
echo -e "loading done: $SECONDS seconds"
