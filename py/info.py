import json
import yaml
import sys
import math
from collections import OrderedDict
import networkx as nx
def knowm(n):#求m值
    m = math.ceil(pow(n,1/3))
    return m
def defx(n,x):

    #n为待转换的十进制数，x为机制，取值为2-16
    a=[0,1,2,3,4,5,6,7,8,9,'A','b','C','D','E','F']
    b=[]
    while True:
        s=n//x  # 商
        y=n%x  # 余数
        b=b+[y]
        if s==0:
            break
        n=s

    if len(b)<3:
        lens = len(b)
        for i in range(lens,3):
            b=b+[0]
    b.reverse()
    return b
def surround(x,m):#寻找邻居节点
    list =[]

    for i in range(0,3):
        if x[i]+1>=0 and x[i]+1<m:
            y=[]
            y=y+x
            y[i] = y[i]+1
            list.append(y)
        if x[i] - 1 >= 0:
            y = []
            y = y + x
            y[i] = y[i] - 1
            list.append(y)
    return list
def cal_surround(N,n):
    m = knowm(N)  # 求m 边长
    target = defx(n,m)  # 求对应坐标
    # print (target)
    list = surround(target,m)  # 每个节点周围的邻居节点
    return list
def name_surround(N,n):
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

#生成每个node对应的endtrypoint
def gen_nx_graph(N):
    g = nx.Graph()
    g.clear()
    g.add_nodes_from(nx.path_graph(N))
    for i in range(0,N):
        nei_list = name_surround(N,i)
        for j in range(0,len(nei_list)):
            # print (nei_list[j])
            g.add_edge(i,nei_list[j])
    return g
def name_gen(N,n):
    g = gen_nx_graph(N)
    p = nx.shortest_path(g, source=n, target=0)
    target = p[1]
    str1 = str(target+1)
    return str1

def change_name(data):
    new_list = list()
    for i in range(0,len(data)):
        #分片
        for j in range(0,len(data[i])):
            #每个分片的节点信息,节点姓名唯一标识
            # print (data[i][j]['NodeName'])
            new_list.append(data[i][j])
    return new_list
#读取数据并且生成邻居
with open('./network/topogensis.json','r') as f:
     data = f.read()
     data = json.loads(data)
     for i in range(len(data)):
           for j in range(0,len(data[i])):
               data[i][j]["Neighbor"] = name_surround(64,int(data[i][j]["Coordinate"]))
            #    print (data[i][j])

     data = change_name(data)
     
f.close()
with open("./network/data.json","w") as f:
    json.dump(data,f)
    print("写入完成")
# 节点信息完成
f.close()
#处理分片信息
str1=list()
with open("shard.json","r") as f:
    data = f.read()
    data = json.loads(data)
    for i in range(len(data)):
        data1 = json.dumps(data[i])
        data1 = data1.replace("\"", "\"")
        data1 = "\""+data1+"\""
        print (data1)
        str1.append(data1)
with open("./network/shard.json","w") as f:
    json.dump(str1,f)
    print("写入完成")