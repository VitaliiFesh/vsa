#!/usr/bin/pwsh

Import-Module ./functions_validation.ps1
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
$switchObjects_1 = Get-VirtualSwitch -VMHost $ESXiHost1 | Select-Object Name, Nic, MTU, VLanID, SwitchType

#Creating switch objects in case I need to manipulate their data
$switches1 = Get-VirtualSwitch | Select-Object Name, Nic, MTU
$switchObjects1 = @()
foreach ($switch in $switches1) {
    $switchObject = New-Object -TypeName psobject
    $switchObject | Add-Member -MemberType NoteProperty -Name Name -Value $switch.Name
    $switchObject | Add-Member -MemberType NoteProperty -Name Nic -Value $switch.Nic
    $switchObject | Add-Member -MemberType NoteProperty -Name MTU -Value $switch.MTU
    $switchObjects1 += $switchObject
}

#StarWind VM networks
#Find a VSA VM on the host
$vmName = "StarWindVSA_01_Feshchenko"
VSA-VM "$vmName"

Disconnect-VIServer $ESXiHost1 -Confirm:$false



#SECOND NODE###############################################
Connect-VIServer $ESXiHost2 -User $ESXiUser2 -Password $ESXiPassword2 | Out-Null

#Getting switch info via the command below
$switchObjects_2 = Get-VirtualSwitch -VMHost $ESXiHost2 | Select-Object Name, Nic, MTU

#Creating switch objects in case I need to manipulate their data
$switches2 = Get-VirtualSwitch | Select-Object Name, Nic, MTU
$switchObjects2 = @()
foreach ($switch in $switches2) {
    $switchObject = New-Object -TypeName psobject
    $switchObject | Add-Member -MemberType NoteProperty -Name Name -Value $switch.Name
    $switchObject | Add-Member -MemberType NoteProperty -Name Nic -Value $switch.Nic
    $switchObject | Add-Member -MemberType NoteProperty -Name MTU -Value $switch.MTU
    $switchObjects2 += $switchObject
}



Disconnect-VIServer $ESXiHost2 -Confirm:$false

#### Disconnection from all nodes ####

$table1 = $switchObjects_1 | Format-Table -AutoSize | Out-String
$table2 = $switchObjects_2 | Format-Table -AutoSize | Out-String

Write-Output $ESXiHost1
Write-Output $table1 
Write-Output $ESXiHost2
Write-Output $table2
