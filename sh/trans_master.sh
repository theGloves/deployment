source ./sh/head.sh

# 上传镜像
sudo docker push ${image}

## 到每个服务器上依次拉取镜像
for (( i=135; i <= 142 ; i++ ))
do
	ssh  -o StrictHostKeyChecking=no -i $workdir/key/ruc_500_new centos@10.77.70.$i "sudo docker pull ${image}"
	ssh  -o StrictHostKeyChecking=no -i $workdir/key/ruc_500_new centos@10.77.70.$[$i+28] "sudo docker pull ${image}" &
done
