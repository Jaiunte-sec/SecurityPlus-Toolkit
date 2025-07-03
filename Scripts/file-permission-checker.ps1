# file-permission-checker.ps1
# Audits folder permissions and flags overly permissive access

$TargetPath = Read-Host "Enter folder path to audit"
$Folders = Get-ChildItem -Path $TargetPath -Recurse -Directory

foreach ($Folder in $Folders) {
    $ACL = Get-Acl $Folder.FullName
    foreach ($Access in $ACL.Access) {
        if ($Access.IdentityReference -eq "Everyone" -and $Access.FileSystemRights -match "FullControl") {
            Write-Host "⚠️ Over-permissive access found in: $($Folder.FullName)" -ForegroundColor Red
        }
    }
}
