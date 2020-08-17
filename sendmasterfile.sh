workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
rm -rf /root/NFS500/network
mkdir /root/NFS500/network
wait
echo -e "delete done: $SECONDS seconds"
cp  -r $workdir/network /root/NFS500
chmod 777 -R /root/NFS500/network

wait
echo -e "send done:$SECONDS seconds"
