import sys
data = []
sum = 0
count = 0
shard_count = int(sys.argv[1])
n = int(sys.argv[2])
for line in open("sum.log","r"):
	count = count+1
	try:
		a = line[:-1]
		a = float(a)
		sum = sum+a
	except:
		pass
if shard_count == 0:
	print (sum)
else:
	if n > 1000:
		print (sum)
	else:
		print( sum/((1/n)+1))
		# print( sum)
