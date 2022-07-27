#!/bin/bash
. /etc/ppp/auth.sh
function RecordTraffic()
{
	interface=$(mysql $database -r -N --batch -e "SELECT interface FROM users WHERE interface IS NOT NULL AND user = '$user'")
        if [[ $interface ]]; then
                rx_bytes=$(cat /sys/class/net/$interface/statistics/rx_bytes)
                tx_bytes=$(cat /sys/class/net/$interface/statistics/tx_bytes)
		TBPS=$(( $T2 - $T1 ))
		RBPS=$(( $R2 - $R1 ))
                mysql $database -r -N --batch -e "UPDATE users SET rx_bytes = $rx_bytes, tx_bytes = $tx_bytes, rx_bps = $RBPS, tx_bps = $TBPS WHERE user = '$user'"
        fi
}
user=$1
pppoe_pid=$2
mac_address=$3
interface=$4
ul_shape=$(mysql $database -r -N --batch -e "SELECT ul_shape FROM users WHERE user = '$user'")
dl_shape=$(mysql $database -r -N --batch -e "SELECT dl_shape FROM users WHERE user = '$user'")
T2=0
T1=0
R2=0
R1=0
client_ip=$(mysql $database -r -N --batch -e "SELECT lastIp FROM users WHERE user = '$user'")
while true
do
	if [[ ! $(cat /proc/$pppoe_pid/cmdline | grep "$mac_address") ]]; then
		exit
	fi
	if [[ $(mysql $database -r -N --batch -e "SELECT kickFromSession FROM users WHERE user = '$user'") != "0" ]]; then
		mysql $database -r -N --batch -e "UPDATE users SET kickFromSession = 0 WHERE user = '$user'"
		kill -15 $pppoe_pid
		exit
	fi
	if [[ $(mysql $database -r -N --batch -e "SELECT active FROM users WHERE user = '$user'") != "1" ]]; then
		kill -15 $pppoe_pid
		exit
	fi
	if [[ $ul_shape != $(mysql $database -r -N --batch -e "SELECT ul_shape FROM users WHERE user = '$user'") || $dl_shape != $(mysql $database -r -N --batch -e "SELECT dl_shape FROM users WHERE user = '$user'") ]]; then
		ul_shape=$(mysql $database -r -N --batch -e "SELECT ul_shape FROM users WHERE user = '$user'")
		dl_shape=$(mysql $database -r -N --batch -e "SELECT dl_shape FROM users WHERE user = '$user'")
		wondershaper $interface $dl_shape $ul_shape
	fi
	RecordTraffic
	if (( $(conntrack -L -s "$client_ip" | wc -l) >= 2500 || $(conntrack -L -d "$client_ip" | wc -l) >= 2500 )); then
                kill -15 $pppoe_pid
                exit
        fi
	sleep 20
	R1=$(cat /sys/class/net/$interface/statistics/rx_bytes)
	T1=$(cat /sys/class/net/$interface/statistics/tx_bytes)
	sleep 1
	R2=$(cat /sys/class/net/$interface/statistics/rx_bytes)
	T2=$(cat /sys/class/net/$interface/statistics/tx_bytes)
done
