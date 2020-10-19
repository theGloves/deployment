# -*- coding:UTF-8 -*-

from json import loads
from sys import argv
from numpy import mean, min, max, var, median

from datetime import datetime
import csv

nano2second = 1000000000
timespan = 2 * 60  # 2min


def draw_bar():
    #TODO
    pass


x_axis = ["<2", "<4", "<6", "<8", "<10", "<12", "<14", "<16"]


def get_axis_pos(data):
    for i in range(len(x_axis)):
        if eval("{}{}".format(data, x_axis[i])):
            return i
    return len(x_axis)


def get_axis_name(data):
    for i in range(len(x_axis)):
        if eval("{}{}".format(data, x_axis[i])):
            return x_axis[i]
    return x_axis[len(x_axis) - 1].replace("<", ">=")


# 从文件中读取resp time，同时做好分组
# 返回两个数据，第一个是时间序列的resp time list
# 第二个是按resp time分成若干组的list
def load_data(filename):
    date_list = []
    resp_list = []
    resp_series = []
    resp_bar = [[get_axis_name(i), 0] for i in range(len(x_axis) + 1)]
    with open(filename, "r") as f:
        doc = f.readlines()
        for line in doc:
            # 以tab切分拿到json string
            origin_time = line.split("\t")[0]
            origin_data = line.split("\t")[2]
            jsondata = {}
            try:
                jsondata = loads(origin_data)
            except exception:
                continue
            resp_time = jsondata["times"] / nano2second
            log_time = datetime.strptime(origin_time, "%Y-%m-%dT%H:%M:%S%z")
            if jsondata["index"] == "TxRes":
                resp_list.append(resp_time)
                date_list.append(log_time)

            if jsondata["index"] == "RelayRes":
                # 将resp_time落在对应的组
                resp_bar[get_axis_pos(resp_time)][1] += 1

    start = min(date_list)
    series_points_num = int((max(date_list) - start).seconds / timespan) + 1

    series_list = [[] for i in range(series_points_num)]
    # 将数据根据时间放到对应的桶里
    for i in range(len(resp_list)):
        pos = int(((date_list[i] - start).seconds) / timespan)
        series_list[pos].append(resp_list[i])

    # 求每个序列里面的平均值、均值+方差、最小值
    for i in range(series_points_num):
        resp_series.append((max(series_list[i]), mean(series_list[i]), min(series_list[i])))
    return resp_series, resp_bar


# name指的是表名
# titles指的是数据列名
def save_data(data, name, titles):
    with open('./statistics/' + name, 'w+', encoding='utf-8') as f:
        # 基于文件对象构建 csv写入对象
        csv_writer = csv.writer(f)
        # 写表头
        csv_writer.writerow(titles)
        # 写入csv文件内容
        for d in data:
            csv_writer.writerow(d)


# 两个命令行参数，第一个是分析文件名，第二个是输出文件前缀
if __name__ == "__main__":
    filename = argv[1]
    prefix = argv[2]
    resp_series, resp_bar = load_data(filename)
    save_data(resp_series, prefix + "_series.csv", ["max", "mean", "min"])
    save_data(resp_bar, prefix + "_replyTX" + ".csv", ["x", "count"])
