# coding:utf-8
# 针对单片交易的bench test tool
import sys
import random
import time
shard_count = int(sys.argv[1])  # 分片的个数

r = sys.argv[2] # 发送频率
T = sys.argv[3] # 持续时间
send_count = int(sys.argv[4]) # 片内节点数
rate = sys.argv[5]  # rate
shard="0"

cmds = ""
for i in range(1, send_count+1):
    prefix = "" if i == 1 else " &"
    cmd =  "./dist/tm-bench_simulator -rate {} -r {} -T {} -shard {} 10.43.0.{}:26657".format(
        rate,
        r,
        T,
        shard,
        100+i
    )
    cmds = cmds + prefix + cmd 
print(cmds)
