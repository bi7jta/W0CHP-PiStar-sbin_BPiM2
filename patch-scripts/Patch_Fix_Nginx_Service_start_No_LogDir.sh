#!/bin/bash 
# sudo curl https://www.bi7jta.cn/files/AndyTaylorTweet/updateScripts/Patch_Fix_Nginx_Service_start_No_LogDir.sh | sudo sh

# 检查文件中是否存在指定行
grep -q "ExecStartPre=/bin/mkdir -p /var/log/nginx" /lib/systemd/system/nginx.service

# 如果不存在，则在指定位置插入新行
if [ $? -ne 0 ]; then
    sed -i '/PIDFile=\/run\/nginx.pid/a ExecStartPre=/bin/mkdir -p /var/log/nginx' /lib/systemd/system/nginx.service
    echo "Add ExecStartPre=/bin/mkdir -p /var/log/nginx"
    
    sudo systemctl daemon-reload
    sudo systemctl restart nginx.service
    echo "Restarted Nginx service, Visit your J-Star Dashboard again"
fi

cat /lib/systemd/system/nginx.service

echo "Done" 