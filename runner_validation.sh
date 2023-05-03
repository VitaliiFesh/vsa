#!/bin/bash

function validate_ip {

read -p "Type IP address: " ip_address
if [[ "$ip_address" =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]
then
# if ping success
  if ping -c 3 $ip_address > /dev/null 2>&1
  then
    echo -e "Ping $ip_address \e[32msuccess\e[0m"
    declare -g ip="$ip_address"
    
# if ping failed
  else
    echo -e "Ping $ip_address \e[31mfailed\e[0m"
    while true; do
      read -p "Do you want to try again? (y/n) " choice
      case $choice in
        n)
	  return 1
          break;;
        y)
          validate_ip; break;;
        *)
          echo -e "\e[31mInvalid\e[0m choice.";;
    esac
    done
  fi
else
  echo -e "\e[31mInvalid\e[0m IP"
  while true; do
    read -p "Do you want to try again? (y/n) " choice
    case $choice in
      n)
        break;;
      y)
        validate_ip; break;;
      *)
        echo -e "\e[31mInvalid\e[0m choice.";;
     esac
  done

fi
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
  validate_ip
  if [[ $ip ]]; then
    sed -i 's/\($ESXiHost2 = "\)[^"]*\(".*\)/\1'"$ip"'\2/' cluster-validation.ps1
    
  else
    echo "False"
  fi
fi
# VALIDATION
echo "Validation process. Information is collected."
