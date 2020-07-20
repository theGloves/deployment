workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
cd $workdir/go
go build SendCrossMessage.go
cd $workdir
scp -i $workdir/key/ruc_500_new $workdir/go/SendCrossMessage centos@10.77.70.142:/home/centos/lyh
ssh -i $workdir/key/ruc_500_new centos@10.77.70.142 "cd /home/centos/lyh;sudo docker cp SendCrossMessage 79a2c8eb2263:/dist/SendCrossMessage"