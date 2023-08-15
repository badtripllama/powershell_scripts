<#Microsoft Graph install :
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module Microsoft.Graph -Scope CurrentUser -Force#>

Import-Module AzureADPreview

Connect-AzureAD


$SetDate = (Get-Date).AddDays(-7);
$SetDate = Get-Date($SetDate) -format yyyy-MM-dd

$SetSigninLogs = Get-AzureADAuditSignInLogs -Filter "createdDateTime gt $SetDate" -All $true | select userDisplayName, userPrincipalName, appDisplayName, IpAddress, clientAppUsed, @{Name = 'DeviceOS'; Expression = {$_.DeviceDetail.OperatingSystem}},@{Name = 'Location'; Expression = {$_.Location.City}}

$SetSigninLogs | Export-Csv -Path "C:\Users\jramphul\Desktop\signins.csv" -notype







$founduserstats = Get-AzureADAuditSignInLogs -Filter "status/errorCode ne 0" -All $true | `
Select CreatedDateTime, UserPrincipalName, AppDisplayName, IpAddress




@{Name = 'ErrorCode'; Expression = {$_.Status.ErrorCode}},
@{Name = 'FailureReason'; Expression = {$_.Status.FailureReason}},
@{Name = 'DeviceOS'; Expression = {$_.DeviceDetail.OperatingSystem}},
@{Name = 'Browser'; Expression = {$_.DeviceDetail.Browser}},
@{Name = 'Location'; Expression = {$_.Location.CountryOrRegion}}



