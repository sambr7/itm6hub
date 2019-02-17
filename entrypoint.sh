#!/bin/bash
# Author: Samuel Januario (samuel.januario01@gmail.com)
# Version: 1.0

CANDLEHOME=/opt/IBM/ITM
SILENT_CONFIG="/ms_config.txt"
[ -z "$TEMS" ] && TEMS="TEMS"
pid=0

start_hub () { 

#start the service
OLDHOSTNAME=$(sed -n -e 's/^default|HOSTNAME|\(.*\)|/\1/p' ${CANDLEHOME}/config/.ConfigData/kmsenv)
OLDTEMS=$(cut -f1 -d'|' ${CANDLEHOME}/config/.ConfigData/kmsenv |grep -v default|tail -n 1)

echo "Renaming TEMS ${OLDTEMS} (Hostname: ${OLDHOSTNAME}) to ${TEMS} (Hostname: ${HOSTNAME})"
# Rename ITM hub
mv /opt/IBM/ITM/tables/${OLDTEMS} /opt/IBM/ITM/tables/${TEMS}
mv /opt/IBM/ITM/config/${OLDHOSTNAME}_ms_${OLDTEMS}.config /opt/IBM/ITM/config/${HOSTNAME}_ms_${TEMS}.config
sed -i -e "s/${OLDTEMS}/${TEMS}/g" /opt/IBM/ITM/config/${HOSTNAME}_ms_${TEMS}.config
sed -i -e "s/\/opt\/IBM\/ITM\/config\/${OLDHOSTNAME}_ms_${OLDTEMS}.config/\/opt\/IBM\/ITM\/config\/${HOSTNAME}_ms_${TEMS}.config/" /opt/IBM/ITM/config/.ConfigData/ConfigInfo
sed -i -e "s/${OLDTEMS}/${TEMS}/;s/${OLDHOSTNAME}/${HOSTNAME}/" /opt/IBM/ITM/config/.ConfigData/kmsenv

# Add runtime configuration properties to silent config file
for e in CMSTYPE FIREWALL NETWORKPROTOCOL BK1NETWORKPROTOCOL BK2NETWORKPROTOCOL BK3NETWORKPROTOCOL BK4NETWORKPROTOCOL BK5NETWORKPROTOCOL HOSTNAME IP6HOSTNAME IPPIPEPORTNUMBER IP6PIPEPORTNUMBER KDC_PARTITIONNAME KDC_PARTITIONFILE IPSPIPEPORTNUMBER IP6SPIPEPORTNUMBER PORTNUMBER IP6PORTNUMBER NETNAME LUNAME LOGMODE AUDIT FTO OKFTO HSNETWORKPROTOCOL BK1HSNETWORKPROTOCOL BK2HSNETWORKPROTOCOL BK3HSNETWORKPROTOCOL BK4HSNETWORKPROTOCOL BK5HSNETWORKPROTOCOL MIRROR IP6MIRROR HSIPPIPEPORTNUMBER HSPORTNUMBER HSNETNAME HSLUNAME HSLOGMODE PRIMARYIP SECURITY TEC_EIF TEC_HOST TEC_PORT WORKFLOW KMS_SECURITY_COMPATIBILITY_MODE;
do
        [[ -n "\$${e}" ]] && echo "${e##*_}=\$${e##*_}" >>${SILENT_CONFIG}
done
# Run silent config file
${CANDLEHOME}/bin/itmcmd config -S -t "$TEMS" -p ${SILENT_CONFIG}
${CANDLEHOME}/bin/itmcmd server start "${TEMS}" & wait ${!}

echo "[Hit Ctrl + C key to exit] or run 'docker stop <container>'"
}

start_hub & pid="$!"
# SIGUSR1- Single handler
stop_handler() {
    echo "++++ Stopping TEMS... ++++"
    ${CANDLEHOME}/bin/itmcmd server stop "${TEMS}"
    kill -SIGTERM "$pid"
    wait "$pid"
    echo "++++ Application shutdown complete. ++++"
    exit 0;
}
trap 'kill ${!} ; stop_handler' SIGTERM SIGINT SIGHUP
# wait forever(Alive container.)
while true
do
    tail -f /dev/null & wait ${!}
done