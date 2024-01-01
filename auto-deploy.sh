#!/bin/bash

echo -e "\e[33m  此部署方式为RocketMQ双主机双主从异步同步盘自动部署 提供部分参数调整 剩余参数为 conf/* 默认 \e[0m"

root_dir=$(dirname ${0})

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

read -p " 请输入您要部署的服务器 s1是第一台服务器[用于配置s1文件夹] s2是第二台服务器[用于配置s2文件夹] standalone是单机部署[用于配置standalone文件夹](s1 - 默认 | s2 | standalone) " server_type
server_target=${server_type:-s1}
echo -e "\e[33m  你选择节点的是 - ${server_target} \e[0m"

# 确认IP信息
event_loop=true
while [ ${event_loop} == true ]
do
    read -p " 请输入本节点的 IP地址:" ip_local
    if [ "${ip_local}" != "" ]; then
        echo -e "\e[33m  本节点IP地址 - ${ip_local} \e[0m"
        # 非单机节点需要配置另外一个IP
        if [ "${server_target}" != "standalone" ]; then
            read -p " 请输入其他节点的 IP地址:" ip_other
            if [ "${ip_other}" != "" ]; then
                echo -e "\e[33m  其他节点IP地址 - ${ip_other} \e[0m"
                read -p "请确认 本节点IP - [${ip_local}] 其他节点IP - [${ip_other}] (yes - 默认 | no - 重新输入 | exit - 退出部署): " ip_confirm
                case ${ip_confirm:-yes} in
                'yes')
                    event_loop=false
                    ;;
                'exit')
                    exit
                    ;;
                *)
                    ;;
                esac
            else
                echo -e "\e[31m  其他节点的 IP地址不能为空， 请重新输入 \e[0m"
            fi
        else
            event_loop=false
        fi    
    else
        echo -e "\e[31m  本节点IP地址不能为空， 请重新输入 \e[0m"
    fi
done

# 根据IP信息信息更新配置文件
echo -e "\e[33m 正在更新配置文件... \e[0m"
m_file="${root_dir}/conf/${server_target}/broker-m.conf"
s_file="${root_dir}/conf/${server_target}/broker-s.conf"

if [ -f ${m_file} ]; then
    sed -i "s/brokerIP1=.*/brokerIP1=${ip_local}/g" ${m_file}
    echo -e "\e[31m 主配置文件更新完毕 - ${m_file}... \e[0m"
    cat  ${m_file}
    echo -e "\n"
else
    echo -e "\e[31m 主配置文件不存在 - ${m_file}... \e[0m"
    exit
fi

if [ -f ${s_file} ]; then
    sed -i "s/brokerIP1=.*/brokerIP1=${ip_local}/g" ${s_file}
    echo -e "\e[33m 从配置文件更新完毕 - ${s_file}... \e[0m"
    cat  ${s_file}
    echo -e "\n"
else
    echo -e "\e[31m 从配置文件不存在 - ${s_file}... \e[0m"
    exit
fi

# 确认docker compose 部署文件存在
name_srv="${ip_local}:9876"
if [ "${server_target}" != "standalone" ]; then
    name_srv="${ip_local}:9876;${ip_other}:9876"
fi
compose_file="${root_dir}/compose/docker-compose-${server_target}.yml"
if [ -f ${compose_file} ]; then
    echo -e "\e[33m docker compose配置文件 - ${compose_file}... \e[0m"
    sed -i "s/NAMESRV_ADDR: .*/NAMESRV_ADDR: ${name_srv}/g" ${compose_file}
    cat  ${compose_file}
    echo -e "\n"
else
    echo -e "\e[31m docker compose配置文件不存在 - ${compose_file}... \e[0m"
    exit
fi

# 是否删除原先部署 部署新的
read -p "请输入部署容器方式('' - 默认，直接部署 | down - 停止并删除旧的部署，从新部署):" reset_tye

# 开始发布
echo -e "\e[33m 正在部署中... \e[0m"

deploy_file="${root_dir}/deploy.sh"
[ "${reset_tye}" == 'down' ] && /bin/bash ${deploy_file} ${root_dir}/conf/${server_target}/ ${compose_file} down ||  /bin/bash ${deploy_file} ${root_dir}/conf/${server_target}/ ${compose_file}
echo -e "\e[33m 部署完成... \e[0m"
docker ps -a