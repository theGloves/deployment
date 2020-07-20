# coding:utf-8
import sys

shard_count = int(sys.argv[1])  # 分片的个数

r = sys.argv[2]
T = sys.argv[3]
rate = sys.argv[5]  # rate
cmd_set = ""
if shard_count == 0:

    cmd = "sudo docker exec -i 79a2c8eb2263 bash -c \"cd dist;./tm-bench -rate " + rate + " -r " + r + " -T " + T + " 0S1.test:26657\""
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
    for i in range(0, shard_count ):
        shard_name = str(i)
        shard_node = shard_name + "S1.test:26657"
        cmd = "sudo docker exec -i 79a2c8eb2263 bash -c \"cd dist;./tm-bench -rate " + rate + " -r " + r + " -T " + T + " -as " + Send_shard + " " + shard_node
        if i == (shard_count-1):
            cmd = shard_node + "\""
            cmd_set = cmd_set + "," + cmd
        else:
            if flag == 0:
                cmd_set = cmd
                flag = 1
            else:
                cmd_set = cmd_set + "," + shard_node
    print(cmd_set)
