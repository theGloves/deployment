# coding:utf-8
import sys

shard_count = int(sys.argv[1])  # 分片的个数

r = sys.argv[2]
T = sys.argv[3]
rate = sys.argv[5]  # rate
shard="0"
if shard_count == 1:

    cmd = "cd dist;./tm-bench -rate " + rate + " -r " + r + " -T " + T +" -as "+shard+ " 0S1.tendermint:26657"
    print(cmd)
else:
    Send_shard = ""  # 要发往哪些分片
    for i in range(0, shard_count ):
        a = str(i)
        if i == (shard_count-1):
            Send_shard = Send_shard + a
        else:
            Send_shard = Send_shard + a + ","
    if shard_count == 0:
        Send_shard = Send_shard + ",1"
    flag = 0
    shard_node = ""
    for i in range(0, shard_count ):
        shard_name = str(i)
        if i==0:
            shard_node = "0S1.tendermint:26657"
            continue
        shard_node = shard_node+","+shard_name + "S1.tendermint:26657"
    
    cmd = "cd dist;./tm-bench -rate " + rate + " -r " + r + " -T " + T +" -as " + Send_shard + " " + shard_node
        # if i == (shard_count-1):
        #     cmd = "./tm-bench -rate " + rate + " -r " + r + " -T " + T + " -shard " +shard_name+" -as " + Send_shard + " " + shard_node
        #     cmd_set = cmd_set + " &" + cmd
        # else:
        #     if flag == 0:
        #         cmd_set = cmd
        #         flag = 1
        #     else:
        #         cmd1 = "./tm-bench -rate " + rate + " -r " + r + " -T " + T + " -shard " + shard_name + " -as " + Send_shard + " " + shard_node
        #         cmd_set = cmd_set + " &" + cmd1
    print(cmd)
