#Connect to AzureAD and MSOL

Connect-AzureAD
Connect-MsolService

#get data from file
$usersFromFile = Get-Content "C:\Users\jramphul\Desktop\test1.csv"

#initialise result set
$output = @()

 
#for each line in csv
foreach ($u in $usersFromFile)
{
    Write-Host "Processing $u..."
    $licenses = Get-MsolUser -UserPrincipalName $u | select Licenses -ExpandProperty Licenses

 
#for each license type in license property
    foreach ($license in $licenses)
    {
        $serviceName = $license.ServiceStatus.ServicePlan.ServiceName
        $provisioningStatus = $license.ServiceStatus.ProvisioningStatus

        for ($i = 0; $i -lt $serviceName.Count; $i++)
        {
            $outputLine = [PSCustomObject] 
			@{
                User = $u
                ServiceName = $serviceName[$i]
                ProvisioningStatus = $provisioningStatus[$i]
            }

            $output += $outputLine
        }
    }
}

 
$output | Export-Csv -Path "C:\Users\jramphul\Desktop\exp1.csv" -NoTypeInformation
