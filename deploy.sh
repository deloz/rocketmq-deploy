#!/bin/bash

# 部署参数  /bin/bash deploy.sh 配置文件夹  部署compose文件  down(可选，当存在该值就要先停止并删除之前部署的)
conf_dir=${1}
compose_file=${2}
down_action=${3}

echo -e "\e[33m 获取到的参数 配置文件 - ${conf_dir} 部署文件 - ${conf_dir} 停止并删除之前部署 - ${down_action}\e[0m"

# 查看 配置文件夹 是否存在
if [ -e "${conf_dir}" ]; then
    echo -e "\e[33m 配置文件路径 - ${conf_dir} \e[0m"
else
    echo -e "\e[33m 配置文件路径不存在 \e[0m"
    exit
fi

# 查看 compose_file 是否存在
if [ -f "${compose_file}" ]; then
    echo -e "\e[33m docker部署文件 - ${compose_file} \e[0m"
else
    echo -e "\e[33m docker部署文件不存在 \e[0m"
    exit
fi

# 查看文件是否存在 不存在进行创建
if [ -e "/data/rocketmq/" ]; then
    echo -e "\e[33m /data/rocketmq 文件存储已经存在，跳过创建.... \e[0m"
else
    mkdir -p /data/rocketmq/namesrv/logs
    chmod a+rw /data/rocketmq/namesrv/logs
    mkdir -p /data/rocketmq/master/logs
    chmod a+rw /data/rocketmq/master/logs
    mkdir -p /data/rocketmq/master/store
    chmod a+rw /data/rocketmq/master/store
    mkdir -p /data/rocketmq/master/conf
    mkdir -p /data/rocketmq/salve/logs
    chmod a+rw /data/rocketmq/salve/logs
    mkdir -p /data/rocketmq/salve/store
    chmod a+rw /data/rocketmq/salve/store
    mkdir -p "/data/rocketmq/salve/conf"
fi

# 将配置文件进行覆盖
if [ -f "${conf_dir}broker-m.conf" ]; then
    cp -f ${conf_dir}broker-m.conf /data/rocketmq/master/conf/broker.conf
elif [ -f "${conf_dir}/broker-m.conf" ]; then
    cp -f ${conf_dir}/broker-m.conf /data/rocketmq/master/conf/broker.conf
else
    echo -e "\e[33m 主broker配置文件不存在 \e[0m"
    exit
fi

if [ -f "${conf_dir}broker-s.conf" ]; then
    cp -f ${conf_dir}broker-s.conf /data/rocketmq/salve/conf/broker.conf
elif [ -f "${conf_dir}/broker-s.conf" ]; then
    cp -f ${conf_dir}/broker-s.conf /data/rocketmq/salve/conf/broker.conf
else
    echo -e "\e[33m 从broker配置文件不存在 \e[0m"
    exit
fi

ls /data/rocketmq/master/conf/
ls /data/rocketmq/salve/conf/

# 开始部署
# 如果需要先停止并销毁之前部署的容器
[ "${down_action}" == "down" ] && docker-compose -f ${compose_file} down
# 启动新容器
docker-compose -f ${compose_file} up -d