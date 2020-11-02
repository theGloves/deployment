nodes=$1
shards=$2

for ((i=0;i<$shards;i++));
do
    for ((node=1;node<=$nodes;node++));
    do
        res=`curl -o /dev/null -s -w %{http_code} --connect-timeout 1 http://10.43.${i}.$(($node+100)):26657`
        if [ $res -ne 200 ] ;then
        	echo tt${i}s${node} " failed"
		fi
    done

done
