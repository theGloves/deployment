nodes=$1
shards=$2

# jq .result.sync_info.latest_block_height
for ((i=0;i<$shards;i++));
do
    for ((node=1;node<=$nodes;node++));
    do
#        res=`curl -o /dev/null -s -w %{http_code} --connect-timeout 1 http://10.43.${i}.$(($node+100)):26657`
		res=`curl --connect-timeout 1 http://10.43.${i}.$(($node+100)):26657/status | jq .result.sync_info.latest_block_height`
		echo $res
        #if [ $res -ne 200 ] ;then
        #	echo tt${i}s${node} " failed"
		#fi
    done

done
