#!/bin/bash

ARCHI=$(uname -a)
CPU=$(lscpu | grep -A 0 "Processeur(s)" | grep -Eo '[0-9]{1,2}')
vCPU=$(lscpu | grep -A 0 "Socket(s)" | grep -Eo '[0-9]{1,2}')
TOT_MEM=$(free -h --giga | grep Mem | awk '{printf("%s"), $2}')
USED_MEM=$(free -h --giga | grep Mem | awk '{printf("%s"), $3}')
USED_MEM_PERCENT=$(free -h --giga | grep Mem | awk '{printf("%.2f"), $3/$2*100}')
TOT_DISK=$(df -h --total | grep total | awk '{printf("%s"), $2}')
USED_DISK=$(df -h --total | grep total | awk '{printf("%s"), $3}')
USED_DISK_PERCENT=$(df -h --total | grep total | awk '{printf("%.2f"), $3/$2*100}')
CPU_LOAD=$(mpstat | awk '$12 ~ /[0-9.]+/ {printf("%.1f"), 100-$12}')
REBOOT=$(who -b | awk '{printf("%s"), $3" "$4}')
LVM=$(if [ $(cat /etc/fstab | grep '/dev/mapper' | wc -l) -gt 0 ]; then echo "yes"; else echo "no"; fi)
TCP_CONNECTIONS=$(netstat -natu | grep 'ESTABLISHED' | wc -l)
LOGGED_USERS=$(who | wc -l)
IP=$(hostname -I)
MAC=$(ip link show | grep "ether" | awk '{print $2}')
#SUDO_CMD=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
SUDO_CMD=$(cat /var/log/sudo/sudo.log | grep "COMMAND" | wc -l)

# To add flag -n (to remove the banner)
# change the owner of the file monitoring.sh to root
# and no need drhaouha ALL=(ALL) NOPASSWD: /usr/local/bin/monitoring.sh

wall "#Architecture: $ARCHI
#CPU: $vCPU
#vCPU: $CPU
#Memory Usage: $USED_MEM/$TOT_MEM ($USED_MEM_PERCENT%)
#Disk Usage: $USED_DISK/$TOT_DISK ($USED_DISK_PERCENT%)
#CPU load: $CPU_LOAD%
#Last boot: $REBOOT
#LVM use: $LVM
#TCP Connections: $TCP_CONNECTIONS ESTABLISHED
#User log: $LOGGED_USERS
#Network: IP $IP ($MAC)
#Sudo: $SUDO_CMD cmd"

