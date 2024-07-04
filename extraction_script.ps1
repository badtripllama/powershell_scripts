# Load the Exchange management cmdlets.

Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
Add-PSSnapin Microsoft.Exchange.Management.Powershell.Support

# Import all the modules located in:
#   %windir%\System32\WindowsPowerShell\v1.0\Modules
ImportSystemModules

$usersfromfile = Get-Content "C:\Users\jramphul\Desktop\test.csv"

$userstats = @()
ForEach ($u in $usersfromfile)
{
    Write-Host "Processing $u..."
    
    #get cmdlet can be changed depending on needs.
    $founduserstats = Get-MailboxStatistics $u | `
       Select DisplayName, TotalItemSize, ItemCount, StorageGroupName

    $userstats = $userstats + $founduserstats
}

$userstats | Export-Csv -Path "C:\Users\jramphul\Desktop\userstats.csv" -notype
_________________________________________________________________________________________________________________________
#tenant managed domains extraction

#If you are running this on PowerShell 7+/Core, you need to import the module in compatibility mode:

Import-Module AzureAD -UseWindowsPowerShell

Get-MsolDomain | Export-CSV o365domains.csv

_________________________________________________________________________________________________________________________
#MX Extraction

$usersfromfile = Get-Content "C:\Users\badtripllama\Desktop\test.csv"

$userstats = @()
ForEach ($u in $usersfromfile)
{
    Write-Host "Processing $u..."
    
    #get cmdlet can be changed depending on needs.
    $founduserstats = resolve-dnsname -name $u -Type mx $u | `
       Select Name, NameExchange

    $userstats = $userstats + $founduserstats
}

$userstats | Export-Csv -Path "C:\Users\jramphul\Desktop\userstats.csv" -notype

_________________________________________________________________________________________________________________________

#TXT Extraction
$usersfromfile = Get-Content "C:\Users\jramphul\Desktop\test.csv"

$userstats = @()
ForEach ($u in $usersfromfile)
{
    Write-Host "Processing $u..."
    
    #get cmdlet can be changed depending on needs.
    $founduserstats = resolve-dnsname -name $u -Type txt | `
       Select Name, @{Name='Strings';Expression={[string]::join(“;”, ($_.strings))}}

    $userstats = $userstats + $founduserstats
}

$userstats | Export-Csv -Path "C:\Users\jramphul\Desktop\userstats.csv" -notype
_________________________________________________________________________________________________________________________
