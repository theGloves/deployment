import json
shardcount = 0
Nodecount = 0
with open("config/data.json","r") as f:
    data = f.read()
    data = json.loads(data)
    shardname = ""
    for i in range(len(data)):
        if shardname != data[i]['ShardName']:
            shardcount = shardcount+1
            shardname = data[i]['ShardName']
    Nodecount = int(len(data)/shardcount)
print(str(shardcount)+","+str(Nodecount))