import sys
data = []
sum = 0
rate= 0 
shard_count = int(sys.argv[1])
n = int(sys.argv[2])
for line in open("sum.log","r"):
	a = line[:-1]
	data = a.split(" ")
	sum = data[0]
	rate = data[1]
print(rate,sum)

