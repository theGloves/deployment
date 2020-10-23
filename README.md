# 简介
该项目为shardingbc自动化部署工具    
该项目分成两个部分：1.主链模式。2.拓扑链模式。  

## 环境要求
1. python3
2. go 版本1.13.6以上
3. 编排环境：rancher2.4.8

## 主体参数
配置文件在config/config.json下
- projectpwd: shardingbc项目路径
- topopwd: 重调整项目路径
- projectbin： gobin路径
- depolymentpwd：当前项目路径
- Home：当前用户家目录
- Data：集群配置数据路径
- containerid：测试镜像docker id,
- "image： shardingbc镜像


## k8s-yaml模板参数
模板文件位于config/k8s-template.yaml  

- node_name： 节点名 （tt-1s1）
- shard_name: 节点所属分片名 （-1）
- image: 镜像名(10.77.70.142:5000/shardingbc:v5.0)
- peers： tendermint连接句柄
- count： 片内节点总数 （3）
- node_num: 该节点在片内编号 （0）
- shard_num： 该分片编号 （-1）
- thresholdd：聚合签名门限值 （1）

## 使用说明
- 编译shardingbc源代码&推送镜像
```
make build
```
- 测试工具编译 & 推镜像
  0 编译模拟数据的测试工具；1编译eth的测试工具
```bash
bash trans_tm-bench.sh [0/1]
```
- 创建配置文件
```bash
bash createfilemaster.sh <片内节点数> <分片数>
```
- 快速部署
```bash
make quick
```
- 清除上次部署
```bash
make clean
```
- 使用eth数据测试
```bash
   bash tm-test.sh <分片数> <tx/s> <持续时间> <片内节点数> <跨片比例>
```
- 使用模拟数据测试
```bash
bash tm-simulator.sh <分片数> <tx/s> <持续时间> <片内节点数> <跨片比例>
```
- 使用原生tendermint测试
```bash
bash tm-tendermint.sh <分片数> <tx/s> <持续时间> <片内节点数> <跨片比例>
```
- 使用批量测试脚本
```bash
bash sh/batch_test.sh [-n 片内节点数] [-s 分片数] [-t 每秒发送速率] [-d 测试持续时间] [-i 两次测试间间隔] [-r 跨片率] [-R] [-E]
```


## 链初始化与启动脚本
- 拓扑链模式
    拓扑链主要包括以下脚本：
    - createfiletopo.sh 其主要是生成拓扑链的节点配置信息，并且它是根据目录下的config中配置信息生成主链网络中节点数量与分片数量（这是根据当前目录network生成的。）并且会读取相应主链的配置信息（这是主链生成配置信息时提前放置在config文件夹中）。当然，它也会在当前目录下生成配置信息文件夹：networktopo。
        - 使用方式：createfiletopo.sh X Y（X为分片内节点数Y为分片数）正常不需要分片
    - sendtopofile.sh 其主要是向云上传networktopo文件夹
        - 使用方式：sendtopofile.sh（无参数）
    - stage_quick_topostart.sh 其主要是对目录下源码进行编译，编译成docker并且上传到各服务器。这里主链不同的是打包镜像名字不一致，以区分。
        - 使用方式：stage_quick_ topostart.sh（无参数）


## 镜像汇总
- 10.77.70.142:5000/shardingbc:v5.0
- 10.77.70.142:5000/tendermint_utls:v2.0