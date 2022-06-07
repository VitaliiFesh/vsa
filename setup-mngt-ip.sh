set -e
path='/etc/sysconfig/network-scripts/ifcfg-ens224' 
read -p 'IP address: ' ip

if [[ $ip =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
    read -p 'prefix: ' prefix
    sudo sed -i '/IPADDR=/d' $path
    sudo sed -i '/PREFIX=/d' $path
    sudo sed -i 's/dhcp/none/' $path
    sudo sed -i "s/ONBOOT=yes/&\nIPADDR=$ip\nPREFIX=$prefix/" $path
    sudo systemctl restart network.service
    ifconfig
else
    echo IP is not valid. Try again.
fi
