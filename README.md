# 简介
该项目分成两个部分：1.主链模式。2.拓扑链模式。

主要是生成所需要的配置文件。

其中包括：1.节点信息配置文件。2.生成tendermint镜像。3.与云平台进行交互。4.测试工具的上传与测试。
# 初始化配置

记得配置参数，需要三个：1.tendermint项目地址。2.gobin的地址。3.该项目的地址。

参数为
```json
{
    "projectpwd":"/home/linyihui/go/src/github.com/tendermint/tendermint",
    "projectbin":"/home/linyihui/go/bin",
    "depolymentpwd":"/home/linyihui/go/src/github.com/deployment"
}
```

# 链初始化与启动脚本
- 主链模式
    
    主链模式主要包括以下脚本：
    - createfilemaster.sh 其主要是生成配置文件，并且在当前目录产生一个network文件夹。
        - 使用方式：createfilemaster.sh X Y（X为分片内节点数Y为分片数）
    - sendmasterfile.sh 其主要是向云上传network文件夹
        - 使用方式：sendmasterfile.sh (无参数)
    - stage_quick_start.sh 其主要是对目录下源码进行编译，编译成docker并且上传到各服务器。
        - 使用方式：stage_quick_start.sh（无参数）

- 拓扑链模式
   
    拓扑链主要包括以下脚本：
    - createfiletopo.sh 其主要是生成拓扑链的节点配置信息，并且它是根据目录下的config中配置信息生成主链网络中节点数量与分片数量（这是根据当前目录network生成的。）并且会读取相应主链的配置信息（这是主链生成配置信息时提前放置在config文件夹中）。当然，它也会在当前目录下生成配置信息文件夹：networktopo。
        - 使用方式：createfiletopo.sh X Y（X为分片内节点数Y为分片数）正常不需要分片
    - sendtopofile.sh 其主要是向云上传networktopo文件夹
        - 使用方式：sendtopofile.sh（无参数）
    - stage_quick_topostart.sh 其主要是对目录下源码进行编译，编译成docker并且上传到各服务器。这里主链不同的是打包镜像名字不一致，以区分。
        - 使用方式：stage_quick_ topostart.sh（无参数）
# 测试脚本

- 编译与上传测试工具 
    - tm_tran.sh 其主要功能是1.编译跨片的测试工具并上传到容器之中。2.编译单片测试工具并上传到容器之中。
        - 使用方式：tm_trans.sh 0/1 0表示单片测试工具 1表示跨片测试工具。

    由于测试工具是放置在docker容器中，因此要将编译完的测试工具上传至容器中。注意：这个容器若挂掉，再启动，其容器id会改变。此时，需要更改脚本代码的容器id。需要更改的代码文件有：
    
    1. tm_tran.sh

    2. py/test.py

- 测试性能脚本
    - tm-test.sh 其主要是进行对主链进行测试。

        - 使用方式：tm-test.sh X Y Z K M (X为测试几个分片 Y为每秒发送交易数量 Z为持续时间 K为分片节点总数 M是跨片交易的比例(M为整数))
            - 例子：./tm-test.sh 0 1000 10 4 2 该含义就是测试单片交易10秒，每秒发送交易1000笔，单片节点数量，index被2整除的发送跨片交易。
        - 查看tps：数据保存在当前目录下的tps/tps.log
             - 例子：每一行格式：0(分片数)4(单片节点数) 1000（发送X笔/秒）966.67（测得数据）
           
            建议：测完单片交易就进行绘图。绘图完，将该文件进行删除在测试跨分片数据。

# 云平台启动容器等操作

1. 取到docker-compose.yaml。该文件存储在当前目录下的network文件夹下。建议：做一个同步，避免每一次要进行vi。

2. 复制docker-compose.yaml内容

3. 登陆云平台操作平台。
    
    url：http://10.77.70.135:8888/

    - 选择环境network
4. 填写应用。
    1.	填写应用名称。注意：应用名称一定要写test
    2.	填写docker-compose.yml。即把刚才复制的内容粘贴过来。
    3.	点击创建
5. 生成配置文件等前期工作。这是上述脚本，在此不再赘述。

注意：在doc文件夹中有doc文件可以查看具体如何操作。
-
