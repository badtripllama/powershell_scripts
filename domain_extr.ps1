How can I use Windows PowerShell to easily audit an Office 365 subscription for domains that are attached to it?

Hey, Scripting Guy! Answer Use the Get-MSolDomain cmdlet, and if you want a list in a CSV file for auditing purposes, add
           the Export parameter, for example:

Get-MsolDomain | Export-CSV o365domains.csv





If you are running this on PowerShell 7+/Core, you need to import the module in compatibility mode:


Copy
Import-Module AzureAD -UseWindowsPowerShell