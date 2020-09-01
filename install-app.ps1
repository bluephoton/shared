$nodeVersion = "v12.18.3"
$nodeDownloadUrl = "https://nodejs.org/dist/v12.18.3/node-$($nodeVersion)-x64.msi"
$appFilesBareUrl = "https://raw.githubusercontent.com/bluephoton/shared/master/"
$appFiles = "package.json", "package-lock.json", "app.js"
  

$appFolder = "C:\app"
$nodeMsi = "$($appFolder)\node.msi"


function DownloadFile([string] $fileUrl, [string] $destination) {
    "Downloading '$fileUrl' to '$destination' ..."
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($fileUrl, $destination)
        "Downloading complete"
    } catch {
        "Download failed: $($_.Exception)"
        throw $_
    }
}

# create app folder if it doesn't exist
if(!(Test-Path -PathType Container -Path $appFolder)) {
    "App folder not found, creating ..."
    New-Item -ItemType Directory -Path $appFolder | Out-Null
}

# Get current node version
$currentNodeVersion = ""
if (Get-Command node -errorAction SilentlyContinue) {
    $currentNodeVersion = (node -v)
    "Node installed. Version: $($currentNodeVersion)"
}

if($nodeVersion -eq $currentNodeVersion) {
    "Node already installed"
} else {
    # Download node
    DownloadFile -fileUrl $nodeDownloadUrl -destination $nodeMsi

    # Install node
    "Installing node ..."
    $args = "/i", $nodeMsi, "/quiet", "/norestart"
    Start-Process "msiexec" -ArgumentList $args -Wait
    "Installing node complete"
}

# install app files
"Installing app files ..."
$appFiles | % { DownloadFile -fileUrl "$($appFilesBareUrl)$($_)" -destination "$($appFolder)\$($_)" }
"Installing app files complete"

# Launch app and don't wait
Set-Location -Path $appFolder
#Start-Process "cmd" -ArgumentList '/K "node app\"'
Start-Process node -ArgumentList app
