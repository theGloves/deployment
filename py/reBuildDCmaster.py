#coding:utf-8
import yaml
import sys
import math
from collections import OrderedDict
import networkx as nx
#使dic可以按顺序写入yaml文件中
def dump_anydict_as_map(anydict): 
  yaml.add_representer(anydict, _represent_dictorder) 
 
def _represent_dictorder(self, data): 
  if isinstance(data, tm_node): 
    return self.represent_mapping('tag:yaml.org,2002:map', data.__getstate__().items()) 
  else: 
    return self.represent_mapping('tag:yaml.org,2002:map', data.items()) 
#定义tm_node类
class tm_node(object): 
	def __init__(self, name,volumes,environment,entrypoint,network,tty,links,id1): 
		self.image ='tendermint:latest'
		self.container_name=name
		self.hostname = name		
		self.tty=tty
		self.volumes= volumes
		self.entrypoint = entrypoint
		self.environment = environment
		self.network=network
		self.links = links
		self.id = id1
		#self.logging = logging
	def __getstate__(self): 
		d = OrderedDict()
		d['image']=self.image
		d['container_name'] = self.container_name
		d['hostname'] = self.hostname 
		d['tty']=self.tty
		d['volumes'] = self.volumes 
		d['environment'] = self.environment 
		d['entrypoint']=self.entrypoint
		d['networks']=self.network
        # 开启依赖启动
		if self.id!=1:
			d['links']=self.links
		#d['logging']=self.logging
		return d 
dump_anydict_as_map(tm_node) 



#得到想要新生成的节点的个数
n_node = int(sys.argv[1])
#得到所有node的id，传入的是一个string字符串，以,隔开
str_node_id = sys.argv[2]
shard = sys.argv[3]
#shard_name = chr(int(shard)+65)
shard_count = sys.argv[4]
node_id = str_node_id.split(",")

#启动全新的yaml文件
filename = "docker-compose.yaml"
f = open(filename, "w")
#设置vesrion

if (shard=='0'):
	version = {'version':2}
	yaml.dump(version, f)
#生成persisitent_peers
persisitent_peers=[]
for i in range(1,n_node+1):
	#port = 26656 + (i-1)*10000
	tmp_str = node_id[i-1]+"@"+shard+"S"+str(i)+":"+str(26656)
	persisitent_peers.append(tmp_str)
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
def genname_surround(N,n,list):
    
    str = "tendermint node --p2p.persistent_peers="
    y = 0
    zz = 0
    for i in range(0,len(list)):
        if n!=0:
            if i==0:
                zz = list[0]
                xx =  name_gen1(N,n)
                for j in range(0,len(list)):
                    if xx==list[j]:
                        y = j
                str = str+persisitent_peers[xx]+","
                continue
            if i == y:
                str = str+persisitent_peers[zz]+","
                continue
            str = str+persisitent_peers[list[i]]+","
        else:
            str = str+persisitent_peers[list[i]]+","
    #不允许空区块
    str = str[:-1] + " --moniker=`hostname` --proxy_app=persistent_kvstore"#"
    return str
def tmp_ep(N,n):
    nei_list = name_surround(N, n)
    str = genname_surround(N,n,nei_list)
    return str
#生成每个node对应的endtrypoint
def tmp_endtrypoint(num,n_node):
	str="tendermint node --p2p.persistent_peers="
	for i in range(0,n_node):
		if i!=num-1:

			str = str + persisitent_peers[i]+","
	str = str[:-1] +" --moniker=`hostname` --proxy_app=persistent_kvstore "#--consensus.create_empty_blocks=false"
	
	return str
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
def get_threshold(n):
	divide = int(n / 3)
	thre = divide * 2
	return str(thre)
def name_gen(N,n):
    g = gen_nx_graph(N)
    p = nx.shortest_path(g, source=n, target=0)
    target = p[1]
    str1 = shard+"S"+str(target+1)
    return str1
def name_gen1(N,n):
    g = gen_nx_graph(N)
    p = nx.shortest_path(g, source=n, target=0)
    target = p[1]
    return p[1]
node = {}
# def tmp_ep(num,n_node):
# 	str = "tendermint node --p2p.persistent_peers="
# 	if num != 1:
# 		# for i in range(0,num-1):
# 		if num!=n_node:
# 			str = str + persisitent_peers[num-2]+","+persisitent_peers[num]+","
# 			str = str[:-1]+ " --moniker=`hostname` --proxy_app=persistent_kvstore "
# 		else:
# 			str = str + persisitent_peers[num-2]+","+persisitent_peers[0]+","
# 			str = str[:-1]+ " --moniker=`hostname` --proxy_app=persistent_kvstore "
#
# 	else:
# 		# for i in range(0,n_node):
# 		# 	if i!=num-1:
# 		# 		str = str + persisitent_peers[i]+","
# 		str1 = "tendermint node --p2p.persistent_peers="+persisitent_peers[n_node-1]+","+persisitent_peers[num]
# 		str = str1 +" --moniker=`hostname` --proxy_app=persistent_kvstore "
# 	# str1 = "tendermint node"
# 	# str = str1 +" --moniker=`hostname` --proxy_app=persistent_kvstore "
# 	return str
for i in range(1,n_node+1):
	name = shard+"S"+str(i)

	volumes=["/root/NFS500/network/"+name+"/config:/tendermint/config"]
	# print (n_node,i-1)
	tmp_str = tmp_ep(n_node,i-1)
	nei_list = name_surround(n_node,i-1)

	# tmp_str = tmp_endtrypoint(i,n_node)
	environment=["TASKID="+shard,"TASKINDEX="+str(i),"THRESHOLD="+get_threshold(n_node+1)]
	tty = "true"
	links=[""]
	id1 = i
	if i != 1:
		name1 =  name_gen(n_node,i-1)
		links = [name1]
    # 不允许空区块
    
	entrypoint=["sh", "-c",tmp_str]
	network = {"tendermintnet1":{"aliases":[shard+"S"+str(i)]}}
	#logging = {"driver":"fluentd","options":{"fluentd-address":"10.42.53.118:24224"}}
	tmn = tm_node(name,volumes,environment,entrypoint,network,tty,links,id1)
	node[name] = tmn
	


write_out={'services':node}
yaml.dump(write_out,f) 

f.close()
