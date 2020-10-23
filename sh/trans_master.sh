workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')
image=$(echo $(cat config/config.json | jq ".image")|sed 's/\"//g')

# 上传镜像
sudo docker push ${image}

## 到每个服务器上依次拉取镜像
for (( i=135; i <= 142 ; i++ ))
do
	ssh  -o StrictHostKeyChecking=no -i $workdir/key/ruc_500_new centos@10.77.70.$i "sudo docker pull ${image}"
	ssh  -o StrictHostKeyChecking=no -i $workdir/key/ruc_500_new centos@10.77.70.$[$i+28] "sudo docker pull ${image}"
done
