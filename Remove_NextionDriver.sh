#!/bin/bash

## sudo curl https://www.bi7jta.cn/files/AndyTaylorTweet/updateScripts/Remove_NextionDriver.sh | sudo sh

main_function() {
	mount -o remount,rw /
	systemctl stop dmrgateway; 
	systemctl stop mmdvmhost; 
	systemctl stop nextiondriver;
	rm /usr/local/bin/NextionDriver;
	sudo rm /etc/mmdvmhost.old;
	rm /etc/mmdvmhost.old;

	sed -i "s#\[NextionDriver\]#\[DelNextionDriver\]#g" /etc/mmdvmhost;
	sed -i "s#\[Transparent Data\]#\[DelTransparent Data\]#g" /etc/mmdvmhost; 
	sed -i "s#\/dev/ttyNextionDriver#\modem#g" /etc/mmdvmhost; 

	sudo systemctl disable nextiondriver; 
	sudo rm /lib/systemd/system/nextiondriver.service;
	sudo sed -i  "/nextiondriver/d" /lib/systemd/system/mmdvmhost.service; 
	sudo systemctl daemon-reload; 
	sudo systemctl start mmdvmhost; 
	sudo systemctl start dmrgateway;
	echo "Done Remove NextionDriver！"
 }

 if [ -t 1 ]; then
 	# run via terminal, only output to screen
 	main_function
else
 	# if not run via terminal, log everything into a log file
 	main_function >> /var/log/pi-star/UnInstallNextionDriver.log 2>&1
fi


 