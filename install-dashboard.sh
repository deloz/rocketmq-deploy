#!/bin/bash

mkdir -p /www/wwwroot/rocketmq-dashboard/data

# 生成随机账号
username=$(tr -dc 'a-zA-Z' < /dev/urandom | head -c 8)

# 生成随机密码
# 使用 /dev/urandom 生成随机字符，并通过 base64 编码，再截取前12个字符
password=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 12)

# admin=ok.4-ssffoaOks,1 这个为 账户名=密码,1(管理员) 或者 用户名=密码（普通用户）
# 每行一个用户 该命令可以先创建一个默认管理员 后续可以在该文件中修改
echo "${username}=${password},1" > /www/wwwroot/rocketmq-dashboard/data/users.properties

# 赋予权限 防止不必要的问题
chmod -R a+rw /www/wwwroot/rocketmq-dashboard/data


# 确认IP信息
event_loop=true
while [ ${event_loop} == true ]
do
    read -p " 请输入 namesrv 的 IP地址:" ip_local
    if [ "${ip_local}" != "" ]; then
        echo -e "\e[33m  namesrv IP地址 - ${ip_local} \e[0m"
	event_loop=false
    else
        echo -e "\e[31m  namesrv IP地址不能为空， 请重新输入 \e[0m"
    fi
done


# 如果需要去除密码登录 删除以下 -e "ROCKETMQ_CONFIG_LOGIN_REQUIRED=true"
# 在下方的NAMESRV_ADDR=namesrv1:9876;namesrv2:9876 需要修改成真实IP，
# 多个namesrv用分号隔开
docker run -d --restart=always --name  rmqdashboard -v /www/wwwroot/rocketmq-dashboard/data:/tmp/rocketmq-console/data -e "JAVA_OPTS=-Xmx256M -Xms256M -Xmn128M"  -e "TZ=Asia/Shanghai" -e "ROCKETMQ_CONFIG_LOGIN_REQUIRED=true" -e "NAMESRV_ADDR=${ip_local}:9876" -p 38080:8080 apacherocketmq/rocketmq-dashboard



echo "管理员账号 $username"
echo "管理员密码 $password"
