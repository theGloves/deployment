node_cnt=$1
tendermint_img="tendermint:latest"
shard=$2
shard_count=$3
shard_name=$4
shard_now=$5
workdir=$(echo $(cat config/config.json | jq ".depolymentpwd")|sed 's/\"//g')
ted_dir=$(echo $(cat config/config.json | jq ".projectpwd")|sed 's/\"//g')
ted_bin=$(echo $(cat config/config.json | jq ".projectbin")|sed 's/\"//g')

#./init_data.sh 3 A  
is_osx () {
    [[ "$OSTYPE" =~ ^darwin ]] || return 1
}

init() {
    SED=sed
    if [[ "$OSTYPE" =~ ^darwin ]]; then
        SED=gsed
        if ! which gsed &> /dev/zero ; then
            brew install gnu-sed
        fi

        if ! which jq &> /dev/zero; then
            brew install jq
        fi
    else
        if ! which jq &> /dev/zero; then
            sudo apt-get install jq -y
        fi
    fi

    if is_osx; then
        rm -rf *data
    else
        sudo rm -rf *data
    fi
}

init
default_genesis="./node1_data/config/genesis.json"

Node_str=""

	for (( i = 1; i <= $node_cnt; i++ )); do
	    if ! is_osx; then
		mkdir -p node${i}_data
		chmod 777 node${i}_data
	    fi

	    docker run --rm -v `pwd`/node${i}_data:/tendermint $tendermint_img init

	    if ! is_osx; then
		sudo chmod -R 777 node${i}_data
	    fi

	    node_id=$(docker run --rm -v `pwd`/node${i}_data:/tendermint $tendermint_img show_node_id)
	    echo "Node$i ID: $node_id"
        #添加节点名字到json文件之中
        
	    Node_str=$Node_str$node_id","

	    if [[ $i != 1 ]]; then
		echo $(cat $default_genesis | jq ".validators |= .+ $(cat node${i}_data/config/genesis.json | jq '.validators')") > $default_genesis
	    fi

        #echo "TT${shard_name}Node$i $node_id"$(cat $default_genesis | jq ".chain_id") >> $workdir/topogensis.json
        nodekey="./node${i}_data/config/node_key.json"
        priv_validator_key="./node${i}_data/config/priv_validator_key.json"
	    echo $(cat $default_genesis | jq ".validators[$i-1].name = \"TT${shard_name}Node$i\" ") > $default_genesis
    done

#所有nodeid的字符串，用,隔开
Node_str=${Node_str%?}

#运行python，自动生成配置yaml文件
python3 py/reBuildDCtopo.py $node_cnt $Node_str $shard $shard_count

#将genesis.json统一拷贝
echo $(cat $default_genesis | jq ".validators[0].power = \"1000\" ") > $default_genesis


#echo $(cat $default_genesis | jq ".validators[1].power = \"100\" ") > $default_genesis
for (( i = 2; i <= $node_cnt; i++ )); do
    cp -f $default_genesis ./node${i}_data/config/genesis.json
done
#获取到底全部分片个数，以及分片里面多少个数
nodecount=$(python3 py/calshardnode.py)
array=(${nodecount//,/ })  #在这里是用,进行分割
count=0
for var in ${array[@]}
do 
    if [ $count == 0 ];then
        shard1=$var
    else
        node1=$var
    fi
    let count+=1
done
#替换config.toml文件中的设置，防止无法加入addrbook
for (( i = 1; i <= $node_cnt; i++ )); do
    $SED -i "s/dial_timeout = \"3s\"/dial_timeout = \"10s\"/g" ./node${i}_data/config/config.toml
    $SED -i "s/addr_book_strict = true/addr_book_strict = false/g" ./node${i}_data/config/config.toml
    $SED -i "s#priv_validator_state_file = \"data/priv_validator_state.json\"#priv_validator_state_file = \"config/priv_validator_state.json\"#g" ./node${i}_data/config/config.toml
    echo "##### reconfiguration configuration options #####" >> ./node${i}_data/config/config.toml
    echo "[reconfiguration]" >> ./node${i}_data/config/config.toml
    echo "#Shardcount" >> ./node${i}_data/config/config.toml
	echo "shardcount = \"${shard1}\"" >> ./node${i}_data/config/config.toml
    echo "#nodecount" >> ./node${i}_data/config/config.toml
	echo "nodecount = \"${node1}\"" >> ./node${i}_data/config/config.toml
    echo "#movecount" >> ./node${i}_data/config/config.toml
	echo "movecount = \"4\"" >> ./node${i}_data/config/config.toml
    echo "##### etcdConfig configuration options #####">> ./node${i}_data/config/config.toml
    echo "[etcd]">> ./node${i}_data/config/config.toml
    echo "#etcdname" >> ./node${i}_data/config/config.toml
	echo "etcdname = \"TT${shard_name}Node$i\"" >> ./node${i}_data/config/config.toml
    echo "#etcddir" >> ./node${i}_data/config/config.toml
	echo "etcddir = \"TT${shard_name}Node$i\"" >> ./node${i}_data/config/config.toml
    str1="\""
    for (( j = 1; j <= $node_cnt; j++ )); do
        str="TT${shard_name}Node$j=http://TT${shard_name}Node$j:2380"
        strl=","
        str2="\""
        if [[ ${i} == ${j} ]];then
            str3="TT${shard_name}Node$j=http://TT${shard_name}Node$j:2380"
            if [[ ${j} == $node_cnt ]];then
                str1=$str1$str3$str2
            else
                str1=$str1$str3$strl
            fi
        else
            if [[ ${j} == $node_cnt ]];then
                str1=$str1$str$str2
            else
                str1=$str1$str$strl
            fi
        fi
    done
    echo "#etcdcluster" >> ./node${i}_data/config/config.toml
	echo "etcdcluster = ${str1}" >> ./node${i}_data/config/config.toml
done

