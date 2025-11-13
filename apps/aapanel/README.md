# 使用说明

这是个民间制作的`aaPanel`的`1Panel`商店版本应用;

- WebUI入口：`http://IP地址:面板端口/aapanel`
- 默认账号：`aapanel`
- 密码：`aapanel123`
- 容器内root密码：`aapanel123`

> 容器内数据
- 网站目录:`/www/wwwroot`
- MySQL目录:`/www/server/data`
- 域名数据:`/www/server/panel/vhost`


> 原作者项目相关
>> - https://hub.docker.com/r/aapanel/aapanel
>> - https://github.com/aaPanel/aaPanel


- 提示：为数据持久化运行，相关数据以存储卷方式存储。


# 原项目介绍

* 宝塔面板的国际版
* 在GitHub开源的版本


# aaPanel Docker Deployment
The docker image is officially released by aaPanel

Maintained by: [aaPanel](https://www.aapanel.com)



##How to use

`$docker run -d -p 8886:8888 -p 22:21 -p 443:443 -p 80:80 -p 889:888 -v ~/website_data:/www/wwwroot -v ~/mysql_data:/www/server/data -v ~/vhost:/www/server/panel/vhost aapanel/aapanel:lib`

Now you can access aaPanel at http://youripaddress:8886/ from your host system.

Default username:`aapanel`

Default password:`aapanel123`

####Port usage analysis
Control Panel   : 8888
Phpmyadmin      : 888

####Dir usage analysis
Website data    : /www/wwwroot
Mysql data      : /www/server/data
Vhost file      : /www/server/panel/vhost 

**Note: after the deployment is complete, please immediately modify the user name and password in the panel settings and add the installation entry**


