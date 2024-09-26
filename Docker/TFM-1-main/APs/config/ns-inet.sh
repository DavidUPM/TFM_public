#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
    echo "You must be root to run this script"
    exit 1
fi

# Returns all available interfaces, except "lo" and "veth*".
available_interfaces()
{
   local ret=()

   local ifaces=$(ip li sh | cut -d " " -f 2 | tr "\n" " ")
   read -a arr <<< "$ifaces" 

   for each in "${arr[@]}"; do
      each=${each::-1}
      if [[ ${each} != "lo" && ${each} != veth* ]]; then
         ret+=( "$each" )
      fi
   done
   echo ${ret[@]}
}

IFACE="$1"
#FORCE IFACE
IFACE=`ip route show | grep 'default via' | awk '{print $5}'`
if [[ -z "$IFACE" ]]; then
   ifaces=($(available_interfaces))
   if [[ ${#ifaces[@]} -gt 0 ]]; then
      IFACE=${ifaces[0]}
      echo "Using interface $IFACE"
   else
      echo "Usage: ./ns-inet <IFACE>"
      exit 1
   fi
else
   IFACE=`ip route show | grep 'default via' | awk '{print $5}'`
   echo "Using interface $IFACE"
fi

NS="ns-ap"
VETH="veth1"
VPEER="vpeer1"
VETH_ADDR="10.200.1.1"
VPEER_ADDR="10.200.1.2"

trap cleanup EXIT

cleanup()
{
   ip li delete ${VETH} 2>/dev/null
}

# Remove namespace if it exists.
ip netns del $NS &>/dev/null

# Create namespace
ip netns add $NS


#--------------------------------------------------------------------------------------------------


# Define vlan for all dockers (in host, is the same mac80211_hwsim)
#0-9 for the attacker
#10-39 radios for AP
#40-59 radios for Clients
#60 for nzyme in attacker

#if wlan < 20 (AP wifis) no executed 
if [[ $(iw dev | grep wlan | wc -l) -lt 20 ]] ; then
   sudo modprobe mac80211_hwsim -r
fi

# Carga el módulo del kernel mac80211_hwsim con la opción radios=61,
# sirve para la simulación de hardware dispositivos inalámbricos y permite
# crear interfaces inalámbricas virtuales que se utilizan para emular
# dispositivos WiFi
sudo modprobe mac80211_hwsim radios=61

# Rename interfaces APwlan, ClientWlan, wlan0 wlan5
#TODO?

# Los APs serán 6-39
for I in `seq 6 39` ; do
	PHY=`ls /sys/class/ieee80211/*/device/net/ | grep -B1 wlan$I | grep -Eo 'phy[0-9]+'`
	iw phy $PHY set netns name /run/netns/$NS
done

#--------------------------------------------------------------------------------------------------


# Creamos el enlace veth
ip link add ${VETH} type veth peer name ${VPEER}

# Añadimos peer-1 al namespace
ip link set ${VPEER} netns $NS

# Configuramos IP de ${VETH}
ip addr add ${VETH_ADDR}/24 dev ${VETH}
ip link set ${VETH} up

# Configuramos la IP de ${VPEER}
ip netns exec $NS ip addr add ${VPEER_ADDR}/24 dev ${VPEER}
ip netns exec $NS ip link set ${VPEER} up
ip netns exec $NS ip link set lo up
ip netns exec $NS ip route add default via ${VETH_ADDR}

# Habilita el reenvío de IP en el kernel de Linux permitiendo que el sistema reenvíe paquetes de una interfaz de red a otra
echo 1 > /proc/sys/net/ipv4/ip_forward

# Por defecto se rechazan los paquetes reenviados, a menos que exista una regla que los permita explícitamente
iptables -P FORWARD DROP
# Borra todas las reglas existentes de la cadena FORWARD
iptables -F FORWARD
 
# Borra todas las reglas de la tabla NAT
iptables -t nat -F

# Habilita el enmascarado NAT para 10.200.1.0.
iptables -t nat -A POSTROUTING -s ${VPEER_ADDR}/24 -o ${IFACE} -j MASQUERADE

# Acepta el reenvío de paquetes desde ${IFACE} hacia ${VETH}
iptables -A FORWARD -i ${IFACE} -o ${VETH} -j ACCEPT
# Acepta el reenvío de paquetes desde ${VETH} hacia ${IFACE}
iptables -A FORWARD -o ${IFACE} -i ${VETH} -j ACCEPT

# Nos movemos al namespace ${NS} y ejecutamos startAP.sh
ip netns exec ${NS} /bin/bash /root/startAPs.sh --rcfile <(echo "PS1=\"${NS}> \"")

# if closed
