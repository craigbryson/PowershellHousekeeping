# A script to delete files older than X days
# Author: Craig Bryson
# Usage $> DeleteFilesOlderThan.ps1 -Path C:\Temp [-Retention 90]
Param (
# Parameter $Path
# Path where log files are stored e.g. C:\Temp 
[Parameter(Mandatory=$true)]
[string]$Path,

# Parameter $Retention
# How many days worth of logs to keep
# Defaults to 30
# Accepts an alias of "DaystoKeep"
# Valid range 1-999
[alias ('DaystoKeep')]
[ValidateRange (1,999)]
[int]$Retention=30
)
Write-Verbose "Path for files :: $Path"
Write-Verbose "Retention Days :: $Retention"

if (!(Test-Path $Path)) {
    Write-Output "The specified path does not exist!"

}
else {
    $SearchFiles = Get-ChildItem –Path $Path -Recurse `
    | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-$Retention))} `
    | Select-Object FullName
    $i = 0
foreach ($File in $SearchFiles)
{
    Write-Verbose "Found file to remove :: $($File.FullName)"
    Remove-Item $File.FullName
    $i++
} 
Write-Verbose "Removed $i files"
}