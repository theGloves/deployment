# -*- coding: utf-8 -*-
"""
输入数据格式：
分片数 全网节点数 测试数据 跨片比例 tps
  1      32     8000     2    359.35

输入参数：
0：不同分片数
1：不同全网节点数
2：不同的测试数据量
3: 不同跨片交易比例 1/n

目前还需要添加一个新的数据分量，代码的改动包括跨片比例取倒数以及画图时横轴取百分数（待测试）
"""
import sys
import matplotlib.pyplot as plt
import matplotlib 

#from collections import Iterable  # 导入Iterable类，以便下面判断对象是否可迭代
#得到所有记录制定位置的数据

#此函数用于把跨片交易比例这一数据分量转换为百分数形式
def to_percent(temp, position):
    return '%1.0f'%(10*temp) + '%'
    
def main():
    labels = ['分片个数', '全网节点总数', '测试数据量', '跨片交易比例', 'TPS']
    #读入参数
    xmode = int(sys.argv[1])
    ymode = 4
    
    #从文件中读入数据 
    data = []
    file = open("tps/tps.log", "r")
    line = file.readline()
    while line:
        eachLine = line.strip().split(" ")
        data.append([round(float(num), 3) for num in eachLine])
        line = file.readline()
    file.close()  
    data = sorted(data, key=lambda x:x[xmode])#使x坐标轴上变量递增
    
    #画图
    plt.figure(figsize=(100, 100)) 
    my_font = matplotlib.font_manager.FontProperties(fname="py/simsun.ttc", size=160) #加载中文字体
    plt.xlabel(labels[xmode], fontproperties=my_font)
    plt.ylabel(labels[ymode], fontproperties=my_font)
    #设置横纵轴坐标刻度
    if xmode == 3:
        plt.xticks([1/x[xmode] for x in data], ['%1.0f'%(100/x[xmode]) + '%' for x in data])    
    else:
        plt.xticks([x[xmode] for x in data], [x[xmode] for x in data])
    plt.yticks([y[ymode] for y in data], [y[ymode] for y in data])
    plt.tick_params(direction='in',width=7,length=20, labelsize=130) 
    #设置坐标轴的粗细
    plt.gca().spines['bottom'].set_linewidth(13)
    plt.gca().spines['left'].set_linewidth(13)
    plt.gca().spines['right'].set_linewidth(13)
    plt.gca().spines['top'].set_linewidth(13)

    #横纵坐标
    if xmode == 3:
        plt.plot([1/x[xmode] for x in data], [round(y[ymode], 3) for y in data], 'ko-', markersize=80, linewidth=30)    
    else:
        plt.plot([x[xmode] for x in data], [round(y[ymode], 3) for y in data], 'ko-', markersize=80, linewidth=30)
    plt.savefig("pic/result.png")
main()