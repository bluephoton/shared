$nodeVersion = "v12.18.3"
$nodeDownloadUrl = "https://nodejs.org/dist/v12.18.3/node-$($nodeVersion)-x64.msi"
$appFilesBareUrl = "https://raw.githubusercontent.com/bluephoton/shared/master/"
$appFiles = "package.json", "package-lock.json", "app.js"
  

$appFolder = "C:\app"
$nodeMsi = "$($appFolder)\node.msi"

$logFile = "$($appFolder)\log.txt"

function Log([string]$Text) {
    $Text | Out-File -Append -FilePath $logFile
}


function DownloadFile([string] $fileUrl, [string] $destination) {
    Log -Text "Downloading '$fileUrl' to '$destination' ..."
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($fileUrl, $destination)
        Log -Text "Downloading complete"
    } catch {
        Log -Text "Download failed: $($_.Exception)"
        throw $_
    }
}

# create app folder if it doesn't exist
if(!(Test-Path -PathType Container -Path $appFolder)) {
    Log -Text "App folder not found, creating ..."
    New-Item -ItemType Directory -Path $appFolder | Out-Null
}

# Get current node version
$currentNodeVersion = ""
if (Get-Command node -errorAction SilentlyContinue) {
    $currentNodeVersion = (node -v)
    Log -Text "Node installed. Version: $($currentNodeVersion)"
}

if($nodeVersion -eq $currentNodeVersion) {
    Log -Text "Node already installed"
} else {
    # Download node
    DownloadFile -fileUrl $nodeDownloadUrl -destination $nodeMsi

    # Install node
    Log -Text "Installing node ..."
    $args = "/i", $nodeMsi, "/quiet", "/norestart"
    Start-Process "msiexec" -ArgumentList $args -Wait
    Log -Text "Installing node complete"
}

# install app files
Log -Text "Installing app files ..."
$appFiles | % { DownloadFile -fileUrl "$($appFilesBareUrl)$($_)" -destination "$($appFolder)\$($_)" }
Log -Text "Installing app files complete"

# Launch app and don't wait
Log -Text "Changing to app folder"
Set-Location -Path $appFolder
Log -Text "Starting app ..."
try {
    #Start-Process "cmd" -ArgumentList '/K "node app\"'
    Start-Process node -ArgumentList app
} catch {
    Log -Text "$($_.Exception)"
}
