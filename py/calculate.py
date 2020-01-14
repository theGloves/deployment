import sys
data = []
sum = 0
count = 0
shard_count = int(sys.argv[1])
for line in open("sum.log","r"):
	a = line[:-1]
	a = float(a)
	sum = sum+a
	count = count+1
if shard_count == 0:
	print sum 
else:
	print sum/2


