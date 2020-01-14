#coding:utf-8
import sys
shard_count = int(sys.argv[1]) #分片的个数

r = sys.argv[2]
T = sys.argv[3]
rate = sys.argv[5]#rate
cmd_set =""
if shard_count ==0:
	cmd ="sudo docker exec -i 4e5570ee8622 bash -c \"cd dist;./tm-bench_noshard -rate "+rate+" -r "+r+" -T "+T+" TTANode1.test:26657\""
	print cmd
else:
	Send_shard = "" #要发往哪些分片
	for i in range(1,shard_count+1):
		a = chr(i+64)
		if i == (shard_count):
		   Send_shard = Send_shard+a
		else:
		   Send_shard = Send_shard+a+","
	if shard_count == 1:
		Send_shard = Send_shard +",B"
	flag =0
	for i in range(1,shard_count+1):
		shard_name = chr(i+64)
		shard_node = "TT"+shard_name+"Node1.test:26657"
		cmd = "sudo docker exec -i 4e5570ee8622 bash -c \"cd dist;./tm-bench -rate "+rate+" -r "+r+" -T "+T+" -as "+Send_shard+" "+shard_node
		if i == (shard_count):
			cmd = shard_node+"\""
			cmd_set = cmd_set+","+cmd
		else:
			if flag ==0:
				cmd_set = cmd
				flag =1
			else:
				cmd_set =cmd_set+","+shard_node
	print cmd_set
