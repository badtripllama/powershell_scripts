# Load the Exchange management cmdlets.

Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
Add-PSSnapin Microsoft.Exchange.Management.Powershell.Support

# Import all the modules located in:
#   %windir%\System32\WindowsPowerShell\v1.0\Modules
ImportSystemModules

$usersFromFile = Get-Content "C:\Users\jramphul\Desktop\test.csv"

$userstats = @()
ForEach ($u in $usersFromFile)
{
    Write-Host "Processing $u..."
    $foundUserStats = Get-MailboxStatistics $u | `
        Select DisplayName, TotalItemSize, ItemCount, StorageGroupName
        
    $userstats = $userstats + $foundUserStats
}

$userstats | Export-Csv -Path "C:\Users\jramphul\Desktop\userstats.csv" -notype