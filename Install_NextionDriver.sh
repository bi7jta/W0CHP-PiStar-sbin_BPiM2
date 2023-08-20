#!/bin/bash

## sudo curl https://www.bi7jta.cn/files/AndyTaylorTweet/updateScripts/Install_NextionDriver.sh | sudo sh

main_function() {

	sudo mount -o remount,rw /
	sudo systemctl stop nextiondriver;
	sudo rm /usr/local/bin/NextionDriver;
	sudo rm /etc/mmdvmhost.old;
	sudo sed -i "s#\[NextionDriver\]#\[DelNextionDriver\]#g" /etc/mmdvmhost;
	cd /home/pi-star; 
	echo "Done ..."
	curl -Ls https://www.bi7jta.cn/files/MMDVM_Nextion/Driver/oneKey_install_NextionDriver_CN.sh | sudo bash
    echo "Done Install NextionDriver"
}

if [ -t 1 ]; then
 	# run via terminal, only output to screen
 	main_function
else
 	# if not run via terminal, log everything into a log file
 	main_function >> /var/log/pi-star/InstallNextionDriver.log 2>&1
fi

