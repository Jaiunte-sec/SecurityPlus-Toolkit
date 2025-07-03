# failed-login-logger.ps1
# Logs failed login attempts (Event ID 4625) from Windows Security Event Log

$StartDate = (Get-Date).AddDays(-7)  # Look back 7 days
$Events = Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    ID = 4625
    StartTime = $StartDate
} | ForEach-Object {
    $IPAddress = ($_.Properties | Where-Object { $_.Value -match '(\d{1,3}\.){3}\d{1,3}' }).Value
    if ($IPAddress -and $IPAddress -ne '127.0.0.1') {
        [PSCustomObject]@{
            IPAddress     = $IPAddress
            TimeGenerated = $_.TimeCreated
            Message       = $_.Message
        }
    }
}

# Output results to table
$Events | Format-Table -AutoSize

# Optional: Export to CSV
$Export = Read-Host "Export results to CSV? (Y/N)"
if ($Export -eq 'Y') {
    $Path = "$env:USERPROFILE\Desktop\FailedLogons.csv"
    $Events | Export-Csv -Path $Path -NoTypeInformation
    Write-Host "Exported to $Path"
}
