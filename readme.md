# 前置准备

- 需要 docker 环境 [docker info]
- 需要 docker-compose 环境 [docker-compose --version]
- 在 debian 12 下测试通过
- `RocketMQ`版本为`5.2.0`

# 获取当前机器IP

```shell
sudo /bin/bash get-machine-ip.sh
```

# 部署方式 1：推荐

```shell
sudo -E /bin/bash **/auto-deploy.sh
```

- 部署单机 输入 standalone 即代表单机部署 一主一从
- 部署两主两从 需要两台服务器 s1 代表第一台服务器 s2 代表第二台服务器
- 除却 IP 之外的都走 conf/{s1|s2}/\*的默认配置 如若需要更改请从改配置文件中修改
- 配置文件会面 -m 代表主配置 -s 代表从配置
- 部署文件在于 compose/\*.yml 其中 s1 s2 是指对应服务器 实际部署中会与 shell 交互中的 s1 s2 对应，不可以错乱部署

- 以下为一个示例，当您把当前文件夹拷贝至/root 下, 用户当前处在~目录下

```shell
# 在服务器1执行
sudo -E /bin/bash rocketmq/auto-deploy.sh
# 之后输入s1 然后根据提示输入 S1 ip 和 S2 ip 【特殊说明：standalone 为单机部署，只需要输入本机IP即可】,之后回车操作按照提示操作即可

# 在服务器2执行
sudo -E /bin/bash rocketmq/auto-deploy.sh
# 之后输入s2 然后根据提示输入 S2 ip 和 S1 ip 【特殊说明：standalone 为单机部署，只需要输入本机IP即可】,之后回车操作按照提示操作即可
```

# 部署方式 2：

```shell
sudo -E /bin/bash **/deploy.sh 配置文件路劲[conf/s1]绝对路径内容应于conf内部一致可做配置修改  compose部署文件[compose/docker-compose-s1.yml]应于您的服务器对应每台一个  down[可选字段，写明了就说明要停止并移除之前部署的容器]
```

- 以下为一个示例，当您把当前文件夹拷贝至/root 下, 用户当前处在~目录下

```shell
# 单机部署 一主一从 和下方的部署方式二选一
sudo -E /bin/bash rocketmq/deploy.sh /root/rocketmq/conf/standalone /root/rocketmq/compose/docker-compose-standalone.yml

# 以下为二主二从集群部署
# 在服务器1执行
sudo -E /bin/bash rocketmq/deploy.sh /root/rocketmq/conf/s1 /root/rocketmq/compose/docker-compose-s1.yml

# 在服务器2执行
sudo -E /bin/bash rocketmq/deploy.sh /root/rocketmq/conf/s2 /root/rocketmq/compose/docker-compose-s2.yml
```

# RocketMQ 面板部署

- 面板部署后，会自动生成管理员账号和密码

```shell
sudo -E /bin/bash install-dashboard.sh
```

# 创建Topic

- 面板不支持创建`delay` topic，要进入`broker`里创建
- `cluster_name` 默认为 `DefaultCluster`

```shell
# default
sh mqadmin updateTopic -n <nameserver_address> -t <topic_name> -c <cluster_name>

# normal topic
sh mqadmin updateTopic -n <nameserver_address> -t <topic_name> -c <cluster_name> -a +message.type=NORMAL

# fifo topic
sh mqadmin updateTopic -n <nameserver_address> -t <topic_name> -c <cluster_name> -a +message.type=FIFO

# delay topic
sh mqadmin updateTopic -n <nameserver_address> -t <topic_name> -c <cluster_name> -a +message.type=DELAY

# transaction topic
sh mqadmin updateTopic -n <nameserver_address> -t <topic_name> -c <cluster_name> -a +message.type=TRANSACTION
```

例子:
```shell
sudo -E docker exec -it rmqbroker-m sh -c "sh mqadmin updateTopic -n 192.168.1.118:9876 -t todo -c DefaultCluster -a +message.type=DELAY"
```
