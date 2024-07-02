#If you are running this on PowerShell 7+/Core, you need to import the module in compatibility mode:

Import-Module AzureAD -UseWindowsPowerShell

Get-MsolDomain | Export-CSV o365domains.csv