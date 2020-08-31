$nodeVersion = "v12.18.3"
$nodeDownloadUri = "https://nodejs.org/dist/v12.18.3/node-$($nodeVersion)-x64.msi"
$nodeMsi = "$($PSScriptRoot)\node.msi"

# Get current node version
if (Get-Command node -errorAction SilentlyContinue) {
    $currentNodeVersion = (node -v)
    Write-Host "Node installed. Version: $($currentNodeVersion)"
}

if($nodeVersion -eq $currentNodeVersion) {
    Write-Host "Node already installed"
    return
}

# Download node to current 
Write-Host "Downloading node ..."
try {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($nodeDownloadUri, $nodeMsi)
} catch {
    Write-Host "Failed to download node: $($_.Exception)"
    throw $_
}

# Install node
write-host "installing node ..."
Start-Process $nodeMsi -Wait

