# Load the Exchange management cmdlets.

Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
Add-PSSnapin Microsoft.Exchange.Management.Powershell.Support

# Import all the modules located in:
#   %windir%\System32\WindowsPowerShell\v1.0\Modules
ImportSystemModules

$usersfromfile = Get-Content "C:\Users\...\test.csv"

$userstats = @()
ForEach ($u in $usersfromfile)
{
    Write-Host "Processing $u..."
    
    #get cmdlet can be changed depending on needs.
    $founduserstats = Get-MailboxStatistics $u | `
       Select DisplayName, TotalItemSize, ItemCount, StorageGroupName

    $userstats = $userstats + $founduserstats
}

$userstats | Export-Csv -Path "C:\Users\...\userstats.csv" -notype
