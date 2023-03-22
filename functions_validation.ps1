# Connecting to VSA VM and get VM settings data
function VSA-VM {
    param($vmName)
    $vm = Get-VM -Name $vmname
    if ($vm) {
        Write-Host "Virtual machine: " -nonewline; Write-Host "$($vm.Name)" -f blue
        Write-Host "CPUs: $($vm.NumCpu)"
        Write-Host "Sockets: $($vm.ExtensionData.Config.Hardware.NumCPU / $vm.ExtensionData.Config.Hardware.NumCoresPerSocket)"
        Write-Host "RAM: $($vm.MemoryGB)"
        Write-Host "Version: $($vm.HardwareVersion)"
        $nics = Get-NetworkAdapter -VM $vm
        foreach ($nic in $nics) {
            Write-Host "    Network name: " -nonewline; Write-host "$($nic.NetworkName), $($nic.type)" -f red
        }

    } else {
        Write-Host "VM is not found"
      }
}

# Creating vswitch objects in case I need to manipulate their data

function VSA-HostSwitchObject {
    $switches = Get-VirtualSwitch | Select-Object Name, Nic, MTU
    $switchObjects = @()
    foreach ($switch in $switches) {
        $switchObject = New-Object -TypeName psobject
        $switchObject | Add-Member -MemberType NoteProperty -Name Name -Value $switch.Name
        $switchObject | Add-Member -MemberType NoteProperty -Name Nic -Value $switch.Nic
        $switchObject | Add-Member -MemberType NoteProperty -Name MTU -Value $switch.MTU
        $switchObjects += $switchObject
    return $switchObjects
}
}

function VSA-HostDatastore {
    param($ESXiHost)
    $datastores = Get-Datastore -VMHost $ESXiHost
    return $datastores
}


