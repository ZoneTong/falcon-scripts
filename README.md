# falcon-scripts

小米开源监控系统open-falcon监控采集脚本

## du.sh

该脚本主要是用于监控各目录大小的。

修改脚本中dirs变量或parent_dirs即可监控相应的目录

dirs用于监控明确的目录

parent_dirs用于要批量监控的目录时，填写这些目录的父目录即可

| 指标名 | 注释 |
|--------|------|
|du.bytes.used|目录大小，单位byte|

## proc.sh

该脚本主要用于监控指定进程所用的cpu/内存/io

修改ports或cmds即可监控对应的进程

ports用于以端口号寻找进程监控

cmds用于以进程名寻找进程监控

| 指标名 | 注释 |
|-------|------|
|proc.cpu|进程所占cpu，百分比|
|proc.mem|进程所占内存，单位byte|
|proc.io.in|进程io输入，单位byte|
|proc.io.out|进程io输出，单位byte|

## cmd.sh

该脚本用于一键启动采集脚本

在变量scripts中列出脚本名后

```bash
    bash cmd.sh start  #一键启动
    bash cmd.sh stop   #一键停止
```

请记得替换脚本中push接口的IP端口