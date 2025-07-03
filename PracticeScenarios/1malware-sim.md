# Malware Behavior Simulation

## Objective
Understand how ransomware and trojans behave, and practice using scripts to monitor changes on a Windows system.

## Steps
1. Create a folder called `SensitiveFiles`
2. Simulate a ransomware event: auto-renaming or encrypting files
3. Use PowerShell to track changes and alert on suspicious activity

## PowerShell Snippet (Example)
```powershell
$Path = "C:\SensitiveFiles"
$Watcher = New-Object System.IO.FileSystemWatcher $Path, "*.*"
$Watcher.EnableRaisingEvents = $true
$Watcher.IncludeSubdirectories = $true
$Watcher.NotifyFilter = [System.IO.NotifyFilters]'FileName, LastWrite'

Register-ObjectEvent $Watcher "Changed" -Action {
    Write-Host "File changed: $($Event.SourceEventArgs.Name)"
}
