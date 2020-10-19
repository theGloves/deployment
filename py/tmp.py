yaml_template = "k8s-template.yaml"  # 读取模板文件
template = open(yaml_template, "r").read()

parameters = {"node_name": "tt0s1", "shard_name": 0,    "image": "10.77.70.142:5000/shardingbc:latest",
              "peers": "pasdfabzwe@tt0s2:26657",    "count": 4,    "node_num": 1,    "shard_num": 0,    "threshold": 2}

s = template.format(**parameters)


with open("test.yaml", "w") as f:
    f.write(s)
    f.write("\n")
    f.write(s)