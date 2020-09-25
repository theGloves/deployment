#!/usr/bin/python3
from json import loads
from sys import argv

def avg(l: list):
	if len(l) == 0:
		return 0
	return sum(l) / len(l)

class TxTimes:
	tx_id:str
	phases:{}

	def __init__(self, tx_id):
		self.tx_id = tx_id
		self.phases={}

	def updateVal(self, phase, ptime):
		l = self.phases.get(phase)
		if l is None:
			l = []
		
		l.append(ptime)
		self.phases[phase] = l

	# 返回指定name的差值: avg(phase1) - avg(phase2)
	def sub(self, phase1, phase2):
		nano2second = 1000000000
		
		p1 = self.phases.get(phase1)
		if p1 is None or len(p1) == 0:
			return -1	
		
		p2 = self.phases.get(phase2)
		if p2 is None or len(p2) == 0:
			return -1
		
		d = avg(p1) - avg(p2)
		return d/nano2second

def loadPhases(filename):
	txmap = {}
	with open(filename, "r") as f:
		doc = f.readlines()
		for line in doc:
			#以tab切分拿到json string
			origin_data = line.split("\t")[2]
			jsondata = loads(origin_data)
			tx_id = jsondata["tx_id"]
			phase = jsondata["phase"]
			ptimes = jsondata["times"]
			# 将各阶段phase放到一起，如果有多个取平均值？
			tx = txmap.get(tx_id)
			if tx is None:
				tx = TxTimes(tx_id)
				txmap[tx_id] = tx
			# 更新当前phase值
			tx.updateVal(phase, ptimes)
	return txmap


couples = [("phase21", "phase2", "first_wait"), ("phase3", "phase21", "first_consensus"), ("phase41", "phase4", "second_wait"), ("phase5", "phase41", "second_consensus"), ("phase23", "phase22", "mem_check") ]
vals = []

# 计算各阶段耗时
def analysisPhase(txmap):
	vals = [[] for i in range(len(couples))]	
	for (tx_id, tx) in txmap.items():
		for i in range(len(couples)):
			c = couples[i]
			v = tx.sub(c[0], c[1])
			if v > 0:
				vals[i].append(v)
	
	s = ""
	for i in range(len(couples)):
		c = couples[i]
		s += "{}: {:.3f}(s); ".format(c[2], avg(vals[i]))
	print(s)

if __name__ == '__main__':
	filename = argv[1]
	# filename "/opt/fluentd/data/latency.20200921_0.log"
	txmap = loadPhases(filename)
	analysisPhase(txmap)
