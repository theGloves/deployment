from requests import get
from sys import argv

def TestPing(url, timeout=1):
    resp = get(url, timeout=timeout)
    return resp.status_code == 200

if __name__ == "__main__":
    shards = int(argv[1])
    nodes = int(argv[2])
    print(shards, nodes)
    for shard in range(shards):
        for node in range(nodes):
            print(shard)
            url = "http://10.43.{}.{}".format(shard, 100+node)
            if TestPing(url) == False:
                print("{} failed".format(url))
