# 编译
bash ./generate.sh 
echo "generate docker.tar done"
# 推镜像和配置文件
bash ./trans_master.sh
echo "trans tar to server done"
