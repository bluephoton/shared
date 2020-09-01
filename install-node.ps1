$nodeVersion = "v12.18.3"
$nodeDownloadUri = "https://nodejs.org/dist/v12.18.3/node-$($nodeVersion)-x64.msi"

$appFolder = "C:\app"
$nodeMsi = "$($appFolder)\node.msi"


function DownloadFile([string] $fileUrl, [string] $destination) {
    Write-Host "Downloading '$fileUrl' to '$destination' ..."
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($fileUrl, $destination)
        Write-Host "Downloading complete"
    } catch {
        Write-Host "Download failed: $($_.Exception)"
        throw $_
    }
}

# create app folder if it doesn't exist
if(!(Test-Path -PathType Container -Path $appFolder)) {
    Write-Host "App folder not found, creating ..."
    New-Item -ItemType Directory -Path $appFolder | Out-Null
}

# Get current node version
if (Get-Command node -errorAction SilentlyContinue) {
    $currentNodeVersion = (node -v)
    Write-Host "Node installed. Version: $($currentNodeVersion)"
}

if($nodeVersion -eq $currentNodeVersion) {
    Write-Host "Node already installed"
    return
}

# Download node
DownloadFile -fileUrl $nodeDownloadUri -destination $nodeMsi

# Install node
write-host "Installing node ..."
$args = "/i", $nodeMsi, "/quiet", "/norestart"
Start-Process "msiexec" -ArgumentList $args -Wait
write-host "Installing node complete"
