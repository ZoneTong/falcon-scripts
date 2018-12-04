#!/bin/bash

logdir=$1
: ${logdir:=.}

# 被监控的目录
# dirs="/bgi/redis_data /bgi/docker_image_container"

# 被监控的各子目录的父目录。 若之间有嵌套关系，父目录须放在后面
parent_dirs="/bgi/blockchain_data /bgi/kblockchain_data /bgi/redis_data /bgi/logs /bgi"

hostname=`hostname`
step=60                                                            
metric=",{\"endpoint\":\"$hostname\",\"metric\":\"du.bytes.used\",\"value\":%d,\"step\":$step,\"counterType\":\"GAUGE\",\"timestamp\":%d,\"tags\":\"mount=%s\"}"
olddate=`date +%Y%m%d`
while true; do
    # 获取指标
    > du.tmp
    ts=`date +%s`
    du -b -s $dirs --exclude=overlay >> du.tmp
    du -b -d 1 $parent_dirs --exclude=overlay >> du.tmp
    metrics=`sort -u du.tmp|awk -v metric=$metric -v ts=$ts '{{v=$1;mount=$2;printf metric,v,ts,mount}}'`
    rm du.tmp
    
    # 截取字符串
    if [ "$metrics" != "" ];then
        metrics='['${metrics:1}']'
    fi

    # 保存日志,过一天更改日期
    newdate=`date +%Y%m%d`
    if [ $newdate != $olddate ];then
        mv ${logdir}/du.log ${logdir}/du${olddate}.log
        olddate=$newdate
    fi
    echo $metrics >> ${logdir}/du.log

    curl -X POST -d $metrics   http://192.168.29.244:1988/v1/push
    sleep $step
done

