# 部署方式 1：推荐

```shell
/bin/bash **/auto-deploy.sh
```

- 部署两主两从 需要两台服务器 s1 代表第一台服务器 s2 代表第二台服务器
- 除却 IP 之外的都走 conf/{s1|s2}/\*的默认配置 如若需要更改请从改配置文件中修改
- 配置文件会面 -m 代表主配置 -s 代表从配置
- 部署文件在于 compose/\*.yml 其中 s1 s2 是指对应服务器 实际部署中会与 shell 交互中的 s1 s2 对应，不可以错乱部署

- 以下为一个示例，当您把当前文件夹拷贝至/root 下, 用户当前处在~目录下

```shell
/bin/bash **/deploy.sh 配置文件路劲[conf/s1]绝对路径内容应于conf内部一致可做配置修改  compose部署文件[compose/docker-compose-s1.yml]应于您的服务器对应每台一个  down[可选字段，写明了就说明要停止并移除之前部署的容器]
```

- 以下为一个示例，当您把当前文件夹拷贝至/root 下, 用户当前处在~目录下

```shell
# 在服务器1执行
/bin/bash rocketmq/auto-deploy.sh
# 之后输入s1 然后根据提示输入 S1 ip 和 S2 ip ,之后回车操作按照提示操作即可

# 在服务器2执行
/bin/bash rocketmq/auto-deploy.sh
# 之后输入s2 并输入 S2 ip 和 S1 ip ,之后回车操作按照提示操作即可
```

# 部署方式 2：

```shell
/bin/bash **/deploy.sh 配置文件路劲[conf/s1]绝对路径内容应于conf内部一致可做配置修改  compose部署文件[compose/docker-compose-s1.yml]应于您的服务器对应每台一个  down[可选字段，写明了就说明要停止并移除之前部署的容器]
```

- 以下为一个示例，当您把当前文件夹拷贝至/root 下, 用户当前处在~目录下

```shell
# 在服务器1执行
/bin/bash rocketmq/deploy.sh /root/rocketmq/conf/s1 /root/rocketmq/compose/docker-compose-s1.yml

# 在服务器2执行
/bin/bash rocketmq/deploy.sh /root/rocketmq/conf/s2 /root/rocketmq/compose/docker-compose-s2.yml
```
