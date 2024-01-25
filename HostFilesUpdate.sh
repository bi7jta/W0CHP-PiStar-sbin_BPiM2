#!/bin/bash
#########################################################
#                                                       #
#              HostFilesUpdate.sh Updater               #
#                                                       #
#      Written for Pi-Star (http://www.pistar.uk/)      #
#               By Andy Taylor (MW0MWZ)                 #
#                  Enhanced by W0CHP                    #
#                                                       #
#   Based on the update script by Tony Corbett G0WFV    #
#                                                       #
#########################################################

# Check if we are root
if [ "$(id -u)" != "0" ];then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Get the W0CHP-PiStar-Dash Version
gitBranch=$(git --work-tree=/var/www/dashboard --git-dir=/var/www/dashboard/.git branch | grep '*' | cut -f2 -d ' ')
dashVer=$( git --work-tree=/var/www/dashboard --git-dir=/var/www/dashboard/.git rev-parse --short=10 ${gitBranch} )
psVer=$( grep Version /etc/pistar-release | awk '{print $3}' )
# main vars
CALL=$( grep "Callsign" /etc/pistar-release | awk '{print $3}' )
osName=$( lsb_release -cs )
hostFileURL="https://hostfiles.w0chp.net"
uuidStr=$(egrep 'UUID|ModemType|ModemMode|ControllerType' /etc/pistar-release | awk {'print $3'} | tac | xargs| sed 's/ /_/g')
modelName=$(grep -m 1 'model name' /proc/cpuinfo | sed 's/.*: //')
hardwareField=$(grep 'Model' /proc/cpuinfo | sed 's/.*: //')
hwDeetz="${hardwareField} - ${modelName}"
uaStr="WPSD-HostFileUpdater Ver.# ${psVer} ${dashVer} (${gitBranch}) Call:${CALL} UUID:${uuidStr} [${hwDeetz}] [${osName}]"

# connectivity check
#status_code=$(curl -I -m 3 -A " ConnCheck ${uaStr}" --write-out %{http_code} --silent --output /dev/null ${hostFileURL})
status_code=404 
if [[ $status_code == 20* ]] || [[ $status_code == 30* ]] ; then
    echo "W0CHP Hostfile Update Server connection OK...updating hostfiles."
else
    echo "Hostfile Update Server Change to official pistar.uk and radioid.net ...  "
	# Get the Pi-Star Version
	pistarCurVersion=$(awk -F "= " '/Version/ {print $2}' /etc/pistar-release)
	 
	DMRIDFILE=/usr/local/etc/DMRIds.dat
	DMRHOSTS=/usr/local/etc/DMR_Hosts.txt 
	P25HOSTS=/usr/local/etc/P25Hosts.txt
	YSFHOSTS=/usr/local/etc/YSFHosts.txt 
	NXDNHOSTS=/usr/local/etc/NXDNHosts.txt 
	XLXHOSTS=/usr/local/etc/XLXHosts.txt 
	M17HOSTS=/usr/local/etc/M17Hosts.txt

	DExtraHOSTS=/usr/local/etc/DExtra_Hosts.txt
    DPlusHOSTS=/usr/local/etc/DPlus_Hosts.txt

	#W0CHP独有的本地文件定义
	APRSHOSTS=/usr/local/etc/APRSHosts.txt
	APRSSERVERS=/usr/local/etc/aprs_servers.json
	NXDNIDFILE=/usr/local/etc/NXDN.csv 
	TGLISTBM=/usr/local/etc/TGList_BM.txt
	TGLISTTGIF=/usr/local/etc/TGList_TGIF.txt
	TGLISTFREESTARIPSC2=/usr/local/etc/TGList_FreeStarIPSC.txt
	TGLISTSYSTEMX=/usr/local/etc/TGList_SystemX.txt
	TGLISTFREEDMR=/usr/local/etc/TGList_FreeDMR.txt
	TGLISTDMRPLUS=/usr/local/etc/TGList_DMRp.txt
	TGLISTP25=/usr/local/etc/TGList_P25.txt
	TGLISTNXDN=/usr/local/etc/TGList_NXDN.txt
	TGLISTYSF=/usr/local/etc/TGList_YSF.txt
	BMTGNAMES=/usr/local/etc/BM_TGs.json
	GROUPSTXT=/usr/local/etc/groups.txt
	STRIPPED=/usr/local/etc/stripped.csv
	COUNTRIES=/usr/local/etc/country.csv

	# 默认情况下，curl是不会显示下载进度的。但是，你可以通过使用“-#”或“--progress-bar”选项来启用进度条 -s：静默不输出任何信息

	#sudo curl -#  -o ${DMRIDFILE}  http://125.91.17.122:8090/dmrids-and-hosts/DMRIds.dat --user-agent "Pi-Star_${pistarCurVersion}"
	#sudo curl -#  -o ${P25HOSTS}   http://125.91.17.122:8090/dmrids-and-hosts/P25_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}"
	#sudo curl -#  -o ${YSFHOSTS}   http://125.91.17.122:8090/dmrids-and-hosts/YSF_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}"
	#sudo curl -#  -o ${DMRHOSTS}   http://125.91.17.122:8090/dmrids-and-hosts/DMR_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}"

    HostURL="http://www.pistar.uk/downloads"
    NextionHostURL="https://radioid.net/static"
    #W0CHP_hostFileURL="https://hostfiles.w0chp.net"
    W0CHP_hostFileURL="https://www.bi7jta.org/files/dmrids-and-hosts"

   file="/usr/local/sbin/.git/config"
   if [ -f "$file" ] && grep -q "gitee.com" "$file"; then
		HostURL="https://www.bi7jta.cn/files/dmrids-and-hosts"
		NextionHostURL=${HostURL}
        W0CHP_hostFileURL=${HostURL}

	    echo "Now in Chinse Repositories [gitee.com], HostURL change to ${HostURL}, NextionHostURL ${NextionHostURL} "
        #Not have blank from Agent,
	else 
	    echo "Now in Github Repositories, HostURL is ${HostURL} ,NextionHostURL ${NextionHostURL} ,W0CHP_hostFileURL ${W0CHP_hostFileURL}"
	    #Have blank from pistar.uk,
	fi 
	
	sudo curl -# -o ${DMRHOSTS}  ${HostURL}/DMR_Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}"
	sudo curl -# -o ${XLXHOSTS}  ${HostURL}/XLXHosts.txt --user-agent "Pi-Star_${pistarCurVersion}"

	sudo curl -# -o ${P25HOSTS}  ${HostURL}/P25Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}" 

	sudo curl -# -o ${YSFHOSTS}  ${HostURL}/YSFHosts.txt --user-agent "Pi-Star_${pistarCurVersion}" 

	sudo curl -# -o ${NXDNHOSTS}  ${HostURL}/NXDNHosts.txt --user-agent "Pi-Star_${pistarCurVersion}" 

	#from W0CHP M17_Hosts.txt, Pi-Star: M17Hosts.txt
	sudo curl -# -o ${M17HOSTS}  ${HostURL}/M17Hosts.txt --user-agent "Pi-Star_${pistarCurVersion}" 

	#D-STAR  
	if [ -f /etc/hostfiles.nodextra ]; then
	  # Move XRFs to DPlus Protocol
	  curl -# -o ${DPlusHOSTS} -s ${HostURL}/DPlus_WithXRF_Hosts.txt --user-agent "${uaStr}"
	  curl -# -o ${DExtraHOSTS} -s ${HostURL}/DExtra_NoXRF_Hosts.txt --user-agent "${uaStr}"
	else
	  # Normal Operation
	  curl -# -o ${DPlusHOSTS} -s ${HostURL}/DPlus_Hosts.txt --user-agent "${uaStr}"
	  curl -# -o ${DExtraHOSTS} -s ${HostURL}/DExtra_Hosts.txt --user-agent "${uaStr}"
	fi


	#W0CHP独有的
	# #Generate Host Files
	uaStr="WPSD-HostFileUpdater Ver.# 4.1.6 283205d9d2 (master) Call:BG6THE UUID:00000000130d8a21_MMDVM_stm32usb_Simplex [Raspberry Pi 3 Model B Plus Rev 1.3 - ARMv7 Processor rev 4 (v7l)] [buster]"

	curl -# -o ${APRSHOSTS}  ${W0CHP_hostFileURL}/APRS_Hosts.txt --user-agent "${uaStr}"
	curl -# -o ${APRSSERVERS}  ${W0CHP_hostFileURL}/aprs_servers.json --user-agent "${uaStr}"
	curl -# -o ${TGLISTBM}  ${W0CHP_hostFileURL}/TGList_BM.txt --user-agent "${uaStr}"
	curl -# -o ${TGLISTTGIF}  ${W0CHP_hostFileURL}/TGList_TGIF.txt --user-agent "${uaStr}"
	curl -# -o ${TGLISTFREESTARIPSC2}  ${W0CHP_hostFileURL}/TGList_FreeStarIPSC.txt --user-agent "${uaStr}"
	curl -# -o ${TGLISTSYSTEMX}  ${W0CHP_hostFileURL}/TGList_SystemX.txt --user-agent "${uaStr}"
	curl -# -o ${TGLISTFREEDMR}  ${W0CHP_hostFileURL}/TGList_FreeDMR.txt --user-agent "${uaStr}"
	curl -# -o ${TGLISTDMRPLUS}  ${W0CHP_hostFileURL}/TGList_DMRp.txt --user-agent "${uaStr}"
	curl -# -o ${TGLISTP25}  ${W0CHP_hostFileURL}/TGList_P25.txt --user-agent "${uaStr}"
	curl -# -o ${TGLISTNXDN}  ${W0CHP_hostFileURL}/TGList_NXDN.txt --user-agent "${uaStr}"
	curl -# -o ${TGLISTYSF}  ${W0CHP_hostFileURL}/TGList_YSF.txt --user-agent "${uaStr}"
	curl -# -o ${COUNTRIES}  ${W0CHP_hostFileURL}/country.csv --user-agent "${uaStr}"
	curl -# -o ${BMTGNAMES}  ${W0CHP_hostFileURL}/BM_TGs.json --user-agent "${uaStr}"
    #BM TG List for live caller and nextion screens:
    cp ${BMTGNAMES} ${GROUPSTXT}
    
    #Update DMRids
    if [ -n "$1" ]; then 
    	if [ "$1" == "HostOnly" ]; then
    		echo "Upate NOT including DMRids, Nextion DMRIds ..."
        fi
    else
    	echo "Upate All including DMRids, Nextion DMRIds ..."
	    sudo curl -# -o ${DMRIDFILE} ${HostURL}/DMRIds.dat --user-agent "Pi-Star_${pistarCurVersion}"
	    
	    echo "Update NextionDriver DMRIds from ${NextionHostURL} ... " 
		cd /tmp; sudo rm -f user.*;  
		sudo curl -# -o /tmp/user.csv  ${NextionHostURL}/user.csv --user-agent "Pi-Star_${pistarCurVersion}"
		mv /tmp/user.csv /usr/local/etc/stripped.csv
		stat /usr/local/etc/stripped.csv

        echo "Update NXDN.csv ... "
		curl -# -o ${NXDNIDFILE}  ${W0CHP_hostFileURL}/NXDN.csv --user-agent "${uaStr}" 
		stat ${NXDNIDFILE} 
    fi

    # If there is a DMR override file, add its contents to DMR_Hosts.txt
	if [ -f "/root/DMR_Hosts.txt" ]; then
		cat /root/DMR_Hosts.txt >> ${DMRHOSTS}
	fi
	echo "===============cat /root/DMR_Hosts.txt==============="
	cat /root/DMR_Hosts.txt

	# Add custom YSF Hosts
	if [ -f "/root/YSFHosts.txt" ]; then
		cat /root/YSFHosts.txt >> ${YSFHOSTS}
	fi
	echo "===============cat /root/YSFHosts.txt==============="
	cat /root/YSFHosts.txt

	# Add custom FCS Hosts
	if [ -f "/root/FCSHosts.txt" ]; then
		cat /root/FCSHosts.txt >> ${YSFHOSTS}
	fi
	echo "===============cat /root/FCSHosts.txt==============="
	cat /root/FCSHosts.txt

	# Add custom P25 Hosts
	if [ -f "/root/P25Hosts.txt" ]; then
		cat /root/P25Hosts.txt > /usr/local/etc/P25HostsLocal.txt
	fi
	echo "===============cat /root/P25Hosts.txt==============="
	cat /root/P25Hosts.txt

	# Add local override for M17Hosts
	if [ -f "/root/M17Hosts.txt" ]; then
		cat /root/M17Hosts.txt >> ${M17HOSTS}
	fi
	echo "===============cat /root/M17Hosts.txt==============="
	cat /root/M17Hosts.txt

	# Fix up new NXDNGateway Config HostFile setup
	if [ ! -f "/root/NXDNHosts.txt" ]; then
		touch /root/NXDNHosts.txt
	fi
	echo "===============cat /root/NXDNHosts.txt==============="
	cat /root/NXDNHosts.txt

	if [ ! -f "/usr/local/etc/NXDNHostsLocal.txt" ]; then
		touch /usr/local/etc/NXDNHostsLocal.txt
	fi


	# Add custom NXDN Hosts
	if [ -f "/root/NXDNHosts.txt" ]; then
		cat /root/NXDNHosts.txt > /usr/local/etc/NXDNHostsLocal.txt
	fi

	# XLX override handling
	if [ -f "/root/XLXHosts.txt" ]; then
		cat /root/XLXHosts.txt >> /usr/local/etc/XLXHosts.txt
	fi
	echo "===============cat /root/XLXHosts.txt==============="
	cat /root/XLXHosts.txt

    exit 0
fi


