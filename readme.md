# 前置准备

- 需要 docker 环境 [docker info]
- 需要 docker-compose 环境 [docker-compose --version]
- 在 centos7 下测试通过

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
# 之后输入s2 然后根据提示输入 S2 ip 和 S1 ip ,之后回车操作按照提示操作即可
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

# RocketMQ 面板部署

```shell
mkdir -p /data/rocketmq-dashboard/data
# admin=admin,1 这个为 账户名=密码,1(1代表管理员) 或者 用户名=密码（普通用户） 每行一个用户 改命令可以先创建一个默认管理员 后续可以在该文件中修改
echo "admin=admin,1" > /data/rocketmq-dashboard/data/user.properties
# 赋予权限 防止不必要的问题
chmod -R a+rw /data/rocketmq-dashboard/data
# 如果需要去除密码登录 删除以下 -e "ROCKETMQ_CONFIG_LOGIN_REQUIRED=true"
# 部署了多少台nameserver, 在下方的NAMESRV_ADDR=namesrv1:9876;namesrv2:9876 进行修改，将namesrv改为对应IP；多个用分号隔开
docker run -d --restart=always --name  rmqdashboard -v /data/rocketmq-dashboard/data:/tmp/rocketmq-console/data -e "JAVA_OPTS=-Xmx256M -Xms256M -Xmn128M"  -e "TZ=Asia/Shanghai" -e "ROCKETMQ_CONFIG_LOGIN_REQUIRED=true" -e "NAMESRV_ADDR=namesrv1:9876;namesrv2:9876" -p 8080:8080 apacherocketmq/rocketmq-dashboard
```
