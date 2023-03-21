#!/usr/bin/pwsh

$env:PSModulePath="/root/.local/share/powershell/Modules:/usr/local/share/powershell/Modules:/opt/microsoft/powershell/7/Modules"
$env:HOME="/root"
Set-PowerCLIConfiguration -InvalidCertificateAction ignore -Confirm:$false | Out-Null

$ESXiHost1 = "192.168.13.192"
$ESXiUser1 = "starwind_rescan"
$ESXiPassword1 = "Zxcvb12345!"

#$ESXiHost2 = "192.168.13.191"
#$ESXiUser2 = "starwind_rescan"
#$ESXiPassword2 = "Zxcvb12345!"
Connect-VIServer $ESXiHost1 -User $ESXiUser1 -Password $ESXiPassword1 | Out-Null
#Connect-VIServer $ESXiHost2 -User $ESXiUser2 -Password $ESXiPassword2 | Out-Null

#DATASTORES ##############################
Get-Datastore -VMHost $ESXiHost1

#foreach ($ds in $datastores) {
#    if ($ds.ExtensionData.Info.Vmfs.Extent.DiskName) {
#        $canonicalName = Get-ScsiLun -VMHost $ESXiHost1 -CanonicalName $ds.ExtensionData.Info.Vmfs.Extent.DiskName
#        $numPaths = $canonicalName.CanonicalName.Split(":")[2]
#    } else {
#        $numPaths = "Unknown"
#    }
#    $props = @{
#        Name = $ds.Name
#        CapacityGB = [math]::Round($ds.CapacityGB, 2)
#        FreeSpaceGB = [math]::Round($ds.FreeSpaceGB, 2)
#        NumPaths = $numPaths
#    }
#    New-Object PSObject -Property $props
#}
# | Format-Table -AutoSize

#VMs ##############################
#Get-VM | Select-Object Name, PowerState | Format-Table -AutoSize
$vmName = "StarWindVSA_01_Feshchenko"
$vm = Get-VM -Name $vmname
if ($vm) {
    Write-Host "Virtual machine: " -nonewline; Write-Host "$($vm.Name)" -ForegroundColor Blue
    Write-Host "CPUs: $($vm.NumCpu)"
    Write-Host "Sockets: $($vm.ExtensionData.Config.Hardware.NumCPU / $vm.ExtensionData.Config.Hardware.NumCoresPerSocket)"
    Write-Host "RAM: $($vm.MemoryGB)"
	Write-Host "Version: $($vm.HardwareVersion)"

#NETWORKING ##############################
    $nics = Get-NetworkAdapter -VM $vm
    foreach ($nic in $nics) {
        Write-Host "    Network name: " -nonewline; Write-host "$($nic.NetworkName), $($nic.type)" -f red
        #Write-Host "        MAC address: $($nic.MacAddress)"
    }
} else {
    Write-Host "Virtual machine "StarWindVSA_01_Feshchenko" not found."
}

#COLLECT METRICS ##############################
#Get-VMhost
Get-VirtualSwitch | Select-Object Name, nic, mtu, SwitchType, VLanID | Format-Table -AutoSize
#Get-VMHostNetworkAdapter | Format-Table -Autosize

Disconnect-VIServer $ESXiHost1 -Confirm:$false
#Disconnect-VIServer $ESXiHost2 -Confirm:$false
