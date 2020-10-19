workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')
image=$(echo $(cat config/config.json | jq ".image")|sed 's/\"//g')

# 上传镜像
sudo docker push ${image}

# 到每个服务器上依次拉取镜像
for (( i=181; i <= 196 ; i++ ))
do
	ssh  -o StrictHostKeyChecking=no -i $workdir/key/weektest root@192.168.0.$i "docker login --username=yusfko -p Yu@sf0110 registry-vpc.cn-beijing.aliyuncs.com;docker pull ${image}"
done