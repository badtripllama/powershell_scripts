<#Microsoft Graph install :
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module Microsoft.Graph -Scope CurrentUser -Force#>

Import-Module AzureADPreview

Connect-AzureAD


$SetDate = (Get-Date).AddDays(-7);
$SetDate = Get-Date($SetDate) -format yyyy-MM-dd

$SetSigninLogs = Get-AzureADAuditSignInLogs -Filter "createdDateTime gt $SetDate" -All | select userDisplayName, userPrincipalName, appDisplayName, ipAddress, clientAppUsed, @{Name = 'DeviceOS'; Expression = {$_.DeviceDetail.OperatingSystem}},@{Name = 'Location'; Expression = {$_.Location.City}}
$SetSigninLogs | Export-Csv -Path "C:\Users\jramphul\Desktop\signins.csv" -notype







