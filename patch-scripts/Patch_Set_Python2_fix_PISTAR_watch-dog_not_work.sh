#!/bin/bash 
# sudo curl https://www.bi7jta.cn/files/AndyTaylorTweet/updateScripts/Patch_Set_Python2_fix_PISTAR_watch-dog_not_work.sh | sudo sh

# 检查 /usr/bin/python 是否为 Python 3 版本
if python --version 2>&1 | grep -q "Python 3"; then
    # 如果是 Python 3 版本，则执行下面的命令来修改默认的 Python 版本为 Python 2
    sudo rm /usr/bin/python
    sudo ln -s /usr/bin/python2 /usr/bin/python
    echo "Default Python version is set to Python 2. Now restart pistar-watchdog.service"
    sudo systemctl restart pistar-watchdog.service
else
    # 如果不是 Python 3 版本，则输出一条消息
    echo "Python 3 is not the default Python version."
fi


