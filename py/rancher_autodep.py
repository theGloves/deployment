import requests
from json import dumps, loads
from time import sleep
from sys import argv

# 在默认环境下操作stack
env_id = '1a5'
#stack_api = 'http://123.57.154.19:8080/v2-beta/projects/' + env_id + '/stacks/'

stack_api = 'http://123.57.154.19:8080/v2-beta/projects/' + env_id + '/stacks/'
def _get_attr(raw, attr):
    try:
        data = loads(raw)
        return data.get(attr)
    except Exception as identifier:
        return None


# 删除和等待删除完成
def cleanup():
    stacks_id = []
    try:
        with open(".rancher", "r") as f:
            for line in f.readlines():
                stacks_id.append(line.replace('\n', ''))
    except FileNotFoundError as identifier:
        print(".rancher not exist.")
        return True

    headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
    }

    # delete
    for id in stacks_id:
        requests.delete(
            stack_api + id,
            headers=headers,
        )

    done = 0
    while True:
        if done == len(stacks_id):
            break
        for i in range(len(stacks_id)):
            id = stacks_id[i]
            if id == "":
                continue
            resp = requests.get(stack_api + id, headers=headers)
            if _get_attr(resp.content, "state") == "removed":
                print("{} removed.".format(id))
                stacks_id[i] = ""
                done += 1
    with open(".rancher", 'r+') as f:
        f.truncate(0)
    return True


# 创建单个stack 如果创建失败返回false 如果创建成功触发active动作
# return: stack_id: string, code: boolean
def create_stack(name, yaml):
    headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
    }

    rancher = {
        "name": name,
        "system": False,
        "dockerCompose": yaml,
        "startOnCreate": True
    }

    # craete
    resp = requests.post(
        stack_api,
        headers=headers,
        data=dumps(rancher),
    )

    if resp.status_code != 201:
        print("create stack {} failed.".format(name))
        print(resp.content)
        return '', False

    # 提取新创建stack的id
    stack_id = _get_attr(resp.content, 'id')

    return stack_id, True


def is_healthy(ids):
    headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
    }
    for id in ids:
        # active this stack
        resp = requests.get(
            stack_api + id,
            headers=headers,
        )

        if _get_attr(resp.content, 'healthState') != 'healthy':
            return False
    return True


# 自动化部署yaml流程
# 读取.rancher文件，清理上一次启动的stacks，一行一个id -> 检查所有的状态是否到removed-> 读取yaml文件（不做任何处理） ->
# 依次创建stack，如果成功保存uid，失败则打印日志 -> active stack -> 确认所有stack active后结束程序
def auto_deploy():
    cleanup()
    print("clean done.")

    stack_ids = []

    try:
        with open("network/docker-compose.yaml", "r") as f:
            docker_compose = f.read()
            id, res = create_stack("tendermint", docker_compose)
            if res == True:
                stack_ids.append(id)

        # 将id写入.rancher
        with open(".rancher", "w") as f:
            for id in stack_ids:
                f.write(id + '\n')
    except Exception as identifier:
        print("create stack failed. {}".format(identifier.__context__))



    # 每5s检查一次
    sleep_times = 0

    while is_healthy(stack_ids) == False:
        #检查120s，超时退出
        if sleep_times == 24:
            exit(-1)
        sleep_times += 1
        sleep(5)
    
    print("auto deploy success.")


if __name__ == "__main__":
    if len(argv) > 1 and argv[1] == "clean":
        cleanup()
    else:
        auto_deploy()
