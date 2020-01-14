cd /home/linyihui/bushu
./sh/generate.sh 
echo "generate docker.tar done"
./sh/trans3.sh 8 lyh
echo "trans tar to server done"
./sendtopofile.sh
echo "send newwork done"

