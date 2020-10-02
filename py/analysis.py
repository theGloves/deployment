#!/usr/bin/python3
from json import loads
from sys import argv
from numpy import mean, min, max, var, median


def avg(l: list):
    if len(l) == 0:
        return 0
    return sum(l) / len(l)


class TxTimes:
    tx_id: str
    phases: {}

    def __init__(self, tx_id):
        self.tx_id = tx_id
        self.phases = {}

    def updateVal(self, phase, ptime):
        l = self.phases.get(phase)
        if l is None:
            l = []

        l.append(ptime)
        self.phases[phase] = l

    # 返回指定name的差值:  avg(phase1) - avg(phase2)
    # 如果只有一个参数phase1的话则直接返回phase1对应的值
    def sub(self, phase1, phase2):
        if phase1 is None:
            return -1

        nano2second = 1000000000

        p1 = self.phases.get(phase1)
        if p1 is None or len(p1) == 0:
            return -1

        if phase2 is None or phase2 == "":
            return avg(p1) / nano2second

        p2 = self.phases.get(phase2)
        if p2 is None or len(p2) == 0:
            return -1

        d = avg(p1) - avg(p2)
        return d / nano2second


def loadPhases(filename):
    txmap = {}
    with open(filename, "r") as f:
        doc = f.readlines()
        for line in doc:
            # 以tab切分拿到json string
            origin_data = line.split("\t")[2]
            jsondata = loads(origin_data)
            tx_id = jsondata["tx_id"]
            phase = jsondata["index"]
            ptimes = jsondata["times"]

            tx = txmap.get(tx_id)
            if tx is None:
                tx = TxTimes(tx_id)
                txmap[tx_id] = tx

            # 更新当前phase值，以追加的形式
            tx.updateVal(phase, ptimes)
    return txmap


tx_index = [
    {
        "name": "1mem",
        "formula": [("phase21", "phase2")]
    },
    {
        "name": "memCheck",
        "formula": [("phase40", None)]
    },
    {
        "name": "memSync",
        "formula": [("phase43", "phase42")]
    },
    {
        "name": "2mem",
        "formula": [("phase41", "phase4")]
    },
    {
        "name": "1cons",
        "formula": [("phase3", "phase21")]
    },
    {
        "name": "2cons",
        "formula": [("phase5", "phase41")]
    },
    {
        "name": "package",
        "formula": [("cphase1", None)]
    },
    {
        "name": "blockSync",
        "formula": [("cphase21", "cphase2")]
    },
    {
        "name": "genSign",
        "formula": [("cphase3", None)]
    },
    {
        "name": "genCM",
        "formula": [("cphase4", None)]
    },
]

# 保存同一个指标下的多个数据
vals = []


# 计算各阶段耗时
def analysisPhase(txmap):
    vals = [[] for i in range(len(tx_index))]

    # example: tx_index = [ {"name": "1mem", "formula": [("phase21", "phase2")]}, ]
    for (tx_id, tx) in txmap.items():
        for i in range(len(tx_index)):
            # ff = [("phase21", "phase2")]
            ff = tx_index[i]["formula"]
            #   一个指标可以有多种不同的计算公式
            for formula in ff:
                # formula = ("phase21", "phase2")
                v_avg = tx.sub(formula[0], formula[1])
                # 大于1ms的时间在记录
                if v_avg > 0.001:
                    vals[i].append(v_avg)

    # 每个指标均输出最小值、平均值、最大值、方差值
    # 一行一个指标
    print("name\tmin\tmax\tavg\tmedian\tvar")
    for i in range(len(tx_index)):
        if len(vals[i]) == 0:
            vals[i] = [0]
        name = tx_index[i]["name"]
        print("{}\t{:.3f}\t{:.3f}\t{:.3f}\t{:.3f}\t{:.3f}".format(
            name, min(vals[i]), max(vals[i]), mean(vals[i]), median(vals[i]),
            var(vals[i])))


if __name__ == '__main__':
    filename = argv[1]
    # filename "/opt/fluentd/data/latency.20200921_0.log"
    txmap = loadPhases(filename)
    analysisPhase(txmap)
