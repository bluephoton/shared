$rgName = "mo-rg-cus"
$vmssName = "mo-vmss-01"

# NOTE: add somespace somewhere to force update as call will detect no change and will be no op
$cseConfig = @{
   "fileUris"= @("https://raw.githubusercontent.com/bluephoton/shared/master/install-app.ps1")
   "commandToExecute" = "powershell  -ExecutionPolicy Unrestricted -File install-app.ps1"
}

<#
# first time add extension
Get-AzVmss -ResourceGroupName $rgName -VMScaleSetName $vmssName | `
 Add-AzVmssExtension -Name "customScript" -Publisher "Microsoft.Compute" -Type "CustomScriptExtension" -TypeHandlerVersion 1.9 -Setting $cseConfig | `
  Update-AzVmss
#>

#<#
# to update the config
$vmss = Get-AzVmss -ResourceGroupName $rgName -VMScaleSetName $vmssName
$vmss.VirtualMachineProfile.ExtensionProfile.Extensions[1].Settings = $cseConfig
Update-AzVmss -ResourceGroupName $rgName -VMScaleSetName $vmssName -VirtualMachineScaleSet $vmss
#>

<#
# remove extension
Get-AzVmss -ResourceGroupName $rgName -VMScaleSetName $vmssName | Remove-AzVmssExtension -Name "customScript" | Update-AzVmss
#>