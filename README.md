# lnmp
使用Docker一键生成LNMP开发环境
## 介绍
该镜像基于ubuntu官方的18.04的LTS镜像，包含nginx，php 7.2，mysql 5.7，memcached等服务，并配置好了php的xdebug服务，可以进行php的远程debug和profiler等操作

## 默认的用户和密码

```
#ubuntu
test:123 #先用这个登陆进系统，在su到root
root:123
 
#mysql端口没有开放，请使用ssh隧道模式连接
root:123
```

## 默认端口

默认只开放了30080（html）和30022（ssh）两个端口，要使用mysql客户端管理等功能，请使用ssh隧道模式连接使用，如果需要更改端口，请自行修改docker-compose.yml中的配置

```
ports: #左边为本地端口，右边为docker镜像内端口
- "30080:80" #web端口
- "30022:22" #ssh端口
```

# lnmp文件夹结构介绍

```
#配置
/conf/php #php配置文件夹
/conf/mysql #mysql配置文件夹
/conf/nginx #nginx配置文件夹
 
#mysql
/mysql #mysql的数据文件
 
#www主目录
/html
 
#日志
/logs/access.log #nginx访问日志
/logs/error.log #nginx错误日志
/mysql/error.log #mysql错误日志
/xdebug #xdebug #profiler文件日志
/xdebug.log #xdebug日志
 
#docker dockerfile
/Dockerfile
 
#docker-compose
/docker-compose.yml
```

## 启动和停止镜像
进入文件夹，输入docker compose的启动命令即可，自动完成镜像下载和加载等动作！（更多详情请自行查看docker 的docker compose文档）

```
#默认启动，交互方式
docker-compose up
#后台启动
docker-compose up -d
#停止
docker-compose stop
```

## 基本使用
源文件文件放入/html文件夹中即可

## phpstorm+Xdebug的配置和使用
检查phpstrom的相关配置，理论上默认配置即可，反正我没动过……

### 调试Debug

注意xdebug的端口是9000（这个端口是本地端口，镜像中的xdebug模块会调用本地的9000端口，所以本地才需要打开这个端口，不需要在docker上开放，如果需要改动的，请查阅xdebug配置文章，该镜像的xdebug配置文件在/conf/php/conf.d/xdebug.ini）

确认无误后，使用的时候，只需要点击phpstorm的工具栏右边的监听图标，就会开始php的debug模式了


### 性能分析profiler

确保请求的GET/POST/COOKIES/Header中包含一个“XDEBUG_PROFILE=1”这个参数，例如

http://localhost:30080/phpinfo.php?XDEBUG_PROFILE=1

请求完成后，会在/logs/xdebug/文件夹中生成对应用作性能分析的日志文件，文件名为cachegrind.out.1581068487，后面的数字是秒级的时间戳

生成完文件后，使用phpstrom的Profiler分析工具（菜单位置：Tools->Analyze Xdebug Profiler Snapshot）

选择/logs/xdebug/中刚刚生成的日志文件，就可以分析对应的程序中每一个函数和语句的执行性能和时间情况了

