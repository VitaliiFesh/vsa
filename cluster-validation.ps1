#!/usr/bin/pwsh

Import-Module ./functions_vm.ps1

$env:PSModulePath="/root/.local/share/powershell/Modules:/usr/local/share/powershell/Modules:/opt/microsoft/powershell/7/Modules"
$env:HOME="/root"
Set-PowerCLIConfiguration -InvalidCertificateAction ignore -Confirm:$false | Out-Null

$ESXiHost1 = "192.168.13.192"
$ESXiUser1 = "starwind_rescan"
$ESXiPassword1 = "Zxcvb12345!"

$ESXiHost2 = "192.168.13.191" #in the beggining it needs to ask how many nodes and their IPs
$ESXiUser2 = "starwind_rescan"
$ESXiPassword2 = "Zxcvb12345!"


#FIRST NODE#################################
Connect-VIServer $ESXiHost1 -User $ESXiUser1 -Password $ESXiPassword1 | Out-Null

#Getting switch info via the command below
$switches_1 = Get-VirtualSwitch -VMHost $ESXiHost1 | Select-Object Name, Nic, MTU, VLanID, SwitchType

#StarWind VM networks
#Find a VSA VM on the host
$vmName = "StarWindVSA_01_Feshchenko"
#Get-VirtualPortGroup
#Get-VMHostNetworkAdapter -Name vmk* | Select-Object VMHost, Name, PortGroupName, IP, SubnetMask, MTU, vMotionEnabled
VSA-VM "$vmName"

# Get host datastore
$datastore1 = VSA-HostDatastore "$ESXiHost1"
Disconnect-VIServer $ESXiHost1 -Confirm:$false


#SECOND NODE###############################################
Connect-VIServer $ESXiHost2 -User $ESXiUser2 -Password $ESXiPassword2 | Out-Null

#Getting switch info via the command below
$switches_2 = Get-VirtualSwitch -VMHost $ESXiHost2 | Select-Object Name, Nic, MTU
$datastore2 = VSA-HostDatastore "$EsxiHost2"

Disconnect-VIServer $ESXiHost2 -Confirm:$false

#### Disconnection from all nodes ####

#$table1 = $switches_1 | Format-Table -AutoSize | Out-String
#$table2 = $switches_2 | Format-Table -AutoSize | Out-String

#Write-Host $ESXiHost1 -f blue
#Write-Output $table1 
#Write-Host $ESXiHost2 -f blue
#Write-Output $table2

#Write-Host $ESXiHost1 -f blue
#$datastore1
#Write-Host $ESXiHost1 -f blue
#$datastore2
