#!/bin/bash

function validate_ip {

read -p "What is partner ESXi IP? " esxi2_ip
if [[ "$esxi2_ip" =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]
then
# if ping success
  if ping -c 3 $esxi2_ip > /dev/null 2>&1
  then
    echo -e "Ping $esxi2_ip \e[32msuccess\e[0m"
# if ping failed
  else
    echo -e "Ping $esxi2_ip \e[31mfailed\e[0m"
    while true; do
      read -p "Do you want to try again? (y/n) " choice
      case $choice in
        n)
          break;;
        y)
          validate_ip; break;;
        *)
          echo "Invalid choice, try again. ";;
    esac
    done
  fi
else
  echo "Invalid IP"
  validate_ip
fi
}



read -p "How many nodes? (2 or 3) " number_nodes
if [ "$number_nodes" -gt 2 ]
then
  # if 3 nodes then:
  echo "3 nodes"
else
  # if 2 nodes then: 
  validate_ip
fi
echo "Validation process. Information is collected."

