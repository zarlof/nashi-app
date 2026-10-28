[CmdletBinding()]
param(
    [string]$Destination,
    [switch]$Build,
    [string]$Dotnet,
    [switch]$NoShortcuts
)
$ErrorActionPreference = 'Stop'
$repository = Split-Path $PSScriptRoot -Parent
if (-not $Destination) { $Destination = Join-Path (Split-Path $repository -Parent) 'Nashi' }
$Destination = [IO.Path]::GetFullPath($Destination)
if ($Build) {
    if (-not $Dotnet) {
        $localSdk = Join-Path $env:LOCALAPPDATA 'ZarlofDevTools\dotnet\dotnet.exe'
        $Dotnet = if (Test-Path -LiteralPath $localSdk) { $localSdk } else { 'dotnet' }
    }
    & $Dotnet publish (Join-Path $repository 'windows\Nashi.Windows') -c Release -o $Destination -p:RestoreLockedMode=true
    if ($LASTEXITCODE -ne 0) { throw 'Nashi Windows build failed.' }
}
$executable = Join-Path $Destination 'Nashi.exe'
if (-not (Test-Path -LiteralPath $executable -PathType Leaf)) { throw 'Build Nashi first, or run this script with -Build and a .NET 10 SDK.' }
if (-not $NoShortcuts) {
    $shell = New-Object -ComObject WScript.Shell
    $programs = Join-Path ([Environment]::GetFolderPath('Programs')) 'Zarlof'
    New-Item -ItemType Directory -Path $programs -Force | Out-Null
    $links = @(
        (Join-Path ([Environment]::GetFolderPath('Desktop')) 'Nashi.lnk'),
        (Join-Path $programs 'Nashi.lnk'),
        (Join-Path ([Environment]::GetFolderPath('SendTo')) 'Nashi ile aç.lnk')
    )
    foreach ($link in $links) {
        $shortcut = $shell.CreateShortcut($link)
        $shortcut.TargetPath = $executable
        $shortcut.WorkingDirectory = $Destination
        $shortcut.Description = 'Nashi — Windows dosya dönüştürme ve düzenleme'
        $shortcut.Save()
    }
}
Write-Output "Nashi hazır: $executable"
