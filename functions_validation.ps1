function VSA-VM {
    param($vmName)
    $vm = Get-VM -Name $vmname
    if ($vm) {
        Write-Host "Virtual machine: " -nonewline; Write-Host "$($vm.Name)" -f blue
        Write-Host "CPUs: $($vm.NumCpu)"
        Write-Host "Sockets: $($vm.ExtensionData.Config.Hardware.NumCPU / $vm.ExtensionData.Config.Hardware.NumCoresPerSocket)"
        Write-Host "RAM: $($vm.MemoryGB)"
        Write-Host "Version: $($vm.HardwareVersion)"
    }
}
