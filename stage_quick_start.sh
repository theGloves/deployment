# 编译
./sh/generate.sh 
echo "generate docker.tar done"
# 推镜像和配置文件
./sh/trans_master.sh
echo "trans tar to server done"
# ./sendmasterfile.sh 
# echo "send newwork done"
