#!/bin/bash

function validate_ip {

read -p "Type IP address " ip_address
if [[ "$ip_address" =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]
then
# if ping success
  if ping -c 3 $ip_address > /dev/null 2>&1
  then
    echo -e "Ping $ip_address \e[32msuccess\e[0m"
    ip_status=10
    return $ip_status
# if ping failed
  else
    echo -e "Ping $ip_address \e[31mfailed\e[0m"
    while true; do
      read -p "Do you want to try again? (y/n) " choice
      case $choice in
        n)
          ip_status=11
          return $ip_status
          break;;
        y)
          validate_ip; break;;
        *)
          echo "Invalid choice, try again. (y/n) ";;
    esac
    done
  fi
else
  echo "Invalid IP"
  while true; do
    read -p "Do you want to try again? (y/n) " choice
    case $choice in
      n)
        ip_status=11
        return $ip_status
        break;;
      y)
        validate_ip; break;;
      *)
        echo "Invalid choice, try again (y/n)";;
     esac
  done

fi
ip_status=11
return $ip_status

}


echo  -e "\e[33mHow many nodes? (2 or 3) \e[0m" 
read number_nodes
if [ "$number_nodes" -gt 2 ]
then
  # if 3 nodes then:
  echo "3 nodes"
else
  # if 2 nodes then: 
  echo -e "\e[33mWhat is the partner ESXi node 2 IP address?\e[0m"
ip_status=$(validate_ip)

  if echo "$ip_status" | grep -q "success"; then
     echo "PING WORKS"
  else
     echo "PING DOES NOT WORK"
  fi
fi
# VALIDATION
echo "Validation process. Information is collected."

