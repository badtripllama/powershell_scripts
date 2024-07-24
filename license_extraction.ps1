#Connect to AzureAD and MSOL

Connect-AzureAD
Connect-MsolService

#get data from file
$usersfromfile = Get-Content "C:\Users\jramphul\Desktop\test1.csv"

#initialise result set
$output = @()

#for each line in csv
foreach ($u in $usersfromfile)
{
    Write-Host "Processing $u..."
    $licenses = Get-MsolUser -UserPrincipalName $u | select Licenses -ExpandProperty Licenses

#for each license type in license property
    foreach ($license in $licenses)
    {
        $servicename = $license.ServiceStatus.ServicePlan.ServiceName
        $provisioningstatus = $license.ServiceStatus.ProvisioningStatus

        for ($i = 0; $i -lt $servicename.Count; $i++)
        {
            $outputline = [PSCustomObject] @{
                User = $u
                ServiceName = $servicename[$i]
                ProvisioningStatus = $provisioningstatus[$i]
            }

            $output += $outputline
        }
    }
}
 
$output | Export-Csv -Path "C:\Users\jramphul\Desktop\exp1.csv" -NoTypeInformation
