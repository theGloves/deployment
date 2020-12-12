source ./sh/head.sh

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
