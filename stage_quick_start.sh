cd /home/linyihui/bushu
./sh/generate.sh 
echo "generate docker.tar done"
./sh/trans2.sh 8 lyh
echo "trans tar to server done"
./sendmasterfile.sh 
echo "send newwork done"

