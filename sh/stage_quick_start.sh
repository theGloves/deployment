source ./sh/head.sh
# 编译
bash $workdir/sh/generate.sh 
echo "image build done"
# 推镜像和配置文件
bash $workdir/sh/trans_master.sh
echo "update images done"
