# coding:utf-8
import yaml
import sys
import math
from collections import OrderedDict
import networkx as nx
from json import loads

def knowm(n):  # 求m值
    m = math.ceil(pow(n, 1/3))
    return m


def defx(n, x):
    # n为待转换的十进制数，x为机制，取值为2-16
    a = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'A', 'b', 'C', 'D', 'E', 'F']
    b = []
    while True:
        s = n//x  # 商
        y = n % x  # 余数
        b = b+[y]
        if s == 0:
            break
        n = s
    if len(b) < 3:
        lens = len(b)
        for i in range(lens, 3):
            b = b+[0]
    b.reverse()
    return b


def surround(x, m):  # 寻找邻居节点
    list = []
    for i in range(0, 3):
        if x[i]+1 >= 0 and x[i]+1 < m:
            y = []
            y = y+x
            y[i] = y[i]+1
            list.append(y)
        if x[i] - 1 >= 0:
            y = []
            y = y + x
            y[i] = y[i] - 1
            list.append(y)
    return list


def cal_surround(N, n):
    m = knowm(N)  # 求m 边长
    target = defx(n, m)  # 求对应坐标
    # print (target)
    list = surround(target, m)  # 每个节点周围的邻居节点
    return list


def name_surround(N, n):
    list = cal_surround(N, n)
    nei_list = []
    m = knowm(N)
    for i in range(0, len(list)):
        sum = 0
        for j in range(0, len(list[i])):
            rev_list = []
            rev_list = rev_list + list[i]
            rev_list.reverse()

            sum = sum + rev_list[j] * pow(m, j)
        if sum < N:
            nei_list = nei_list + [sum]
    return nei_list


def genname_surround(N, n, list):
    str = ""
    y = 0
    zz = 0
    for i in range(0, len(list)):
        if n != 0:
            if i == 0:
                zz = list[0]
                xx = name_gen1(N, n)
                for j in range(0, len(list)):
                    if xx == list[j]:
                        y = j
                str = str+persisitent_peers[xx]+","
                continue
            if i == y:
                str = str+persisitent_peers[zz]+","
                continue
            str = str+persisitent_peers[list[i]]+","
        else:
            str = str+persisitent_peers[list[i]]+","
    # 不允许空区块
    str = str[:-1]
    return str


# 生成每个node对应的endtrypoint
def tmp_ep(N, n):
    nei_list = name_surround(N, n)
    str = genname_surround(N, n, nei_list)
    return str


def gen_nx_graph(N):
    g = nx.Graph()
    g.clear()
    g.add_nodes_from(nx.path_graph(N))
    for i in range(0, N):
        nei_list = name_surround(N, i)
        for j in range(0, len(nei_list)):
            g.add_edge(i, nei_list[j])
    return g


def get_threshold(n):
    divide = int(n / 3)
    thre = divide * 2
    return str(thre)


def name_gen1(N, n):
    g = gen_nx_graph(N)
    p = nx.shortest_path(g, source=n, target=0)
    target = p[1]
    return p[1]


# main entry
image_name = "10.77.70.142:5000/tendermint:0.31.4"

# 得到想要新生成的节点的个数
n_node = int(sys.argv[1])
# 得到所有node的id，传入的是一个string字符串，以,隔开
str_node_id = sys.argv[2]
shard = sys.argv[3]
shard_count = sys.argv[4]
node_id = str_node_id.split(",")

template_filename = "config/k8s-template.yaml"  # 读取模板文件
filename = "docker-compose.yaml"  # 输出文件名

template = ""
with open(template_filename, "r") as f:
    template = f.read()

print(sys.argv)
# 生成persisitent_peers
persisitent_peers = []
for i in range(1, n_node+1):
    tmp_str = node_id[i-1]+"@tt"+shard+"s"+str(i)+":"+str(26656)
    persisitent_peers.append(tmp_str)

# 打开待写入的yaml文件
f = open(filename, "w")
for i in range(1, n_node+1):
    name = "tt" + shard+"s"+str(i)

    peers_str = tmp_ep(n_node, i-1)
    nei_list = name_surround(n_node, i-1)

    # environment = ["TASKID="+shard, "TASKINDEX=" + str(), "THRESHOLD="+get_threshold(n_node+1), "Count="+str(n_node)]

    parameters = {"node_name": name,
                  "shard_name": shard,
                  "image": image_name,
                  "peers": peers_str,
                  "count": n_node,
                  "node_num": i,
                  "shard_num": shard,
                  "threshold": get_threshold(n_node+1),
				  "ip_addr": "10.43.{}.{}".format(shard, 100+i)
                  }

    f.write(template.format(**parameters))
    f.write("\n")

f.close()
