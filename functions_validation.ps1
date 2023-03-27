# Connecting to VSA VM and get VM settings data
function VSA-VM {
    param($vmName)
    $vm = Get-VM -Name $vmname
    if ($vm) {
        Write-Host "Virtual machine: " -nonewline; Write-Host "$($vm.Name)" -f blue
        Write-Host "CPUs: " -nonewline;
        if ($vm.NumCpu -lt 4) {
            Write-Host "$($vm.NumCpu)" -f red
        }
        elseif ($vm.NumCpu -lt 8 -and $vm.NumCpu -ge 4) {
            Write-Host "$($vm.NumCpu)" -f yellow
        } 
        else {
            Write-Host "$($vm.NumCpu)" -f green
        }
        Write-Host "Sockets: $($vm.ExtensionData.Config.Hardware.NumCPU / $vm.ExtensionData.Config.Hardware.NumCoresPerSocket)"
        Write-Host "RAM: $($vm.MemoryGB)"
        Write-Host "Version: $($vm.HardwareVersion)"
        # Networking. Highlights with yellow if nic is E1000e; green if vmxnet3
        $nics = Get-NetworkAdapter -VM $vm
        foreach ($nic in $nics) {
            Write-Host "Network: " -nonewline; 
            if ($nic.type -like "*1000*") {
                Write-host "$($nic.NetworkName), $($nic.type)" -f yellow
            }
            elseif ($nic.type -like "*vmx*") {
                Write-Host "$($nic.NetworkName), $($nic.type)" -f green
            }
            else {
                Write-Host "$($nic.NetworkName), $($nic.type)"
            }
        }

    } else {
        Write-Host "VM is not found"
      }

# startup options
    $startup = Get-VMStartPolicy -VM $vmName | Select-Object StartAction, StopAction, StartDelay
    Write-Host "Start Action: " -nonewline;
    if ($startup.StartAction -like "PowerOn") {
       Write-Host $startup.StartAction -f green
    }
    else {
       Write-Host $startup.StartAction -f red
    }
    Write-Host "Stop Action: " -nonewline;
    if ($startup.StopAction -like "GuestShutdown") {
       Write-Host $startup.StopAction -f green
    }
    else {
       Write-Host $startup.StopAction -f red
    }
    Write-Host "Start delay: $($startup.StartDelay)"

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


