# PowerShell script to get A and AAAA records for a list of domains, with debug output

# Define the path to the domain list and output CSV file
$domainListPath = "C:\your\path\domains.txt"
$outputCsvPath = ".\domain_records.csv"

# Read the list of domains from the file
$domains = Get-Content $domainListPath

# Prepare an array to hold the results
$results = @()

# Loop through each domain and query its A and AAAA records
foreach ($domain in $domains) {
    Write-Host "Processing domain: $domain"

    # Initialize the record object
    $record = New-Object PSObject -Property @{
        Domain = $domain
        ARecord = $null
        AAAARecord = $null
		WARecord = $null
		WAAAARecord = $null
    }

    Write-Host "  Performing nslookup..."
    # Perform nslookup for A and AAAA records
    $nslookupResults = nslookup $domain
	$nslookupResults = $nslookupResults | Select-Object -Skip 2

    # Extract A and AAAA records
    foreach ($line in $nslookupResults) {
		Write-Host "Debug output"
		Write-Host $line
        if ($line -match "(\d+\.\d+\.\d+\.\d+)") {
			$address = $matches[1]
			Write-Host "  Found A record: $address"
			$record.ARecord = $address
		} elseif ($line -match "([a-fA-F0-9:]+:[a-fA-F0-9:]+)") {
			$address = $matches[1]
			Write-Host "  Found AAAA record: $address"
			$record.AAAARecord = $address
		}
		
<#         if ($line -match "Address: (.*)") {
            $address = $matches[1]
            # Determine if the address is IPv4 (A record) or IPv6 (AAAA record)
            if ($address -match "\d+\.\d+\.\d+\.\d+") {
                Write-Host "  Found A record: $address"
                $record.ARecord = $address
            } elseif ($address -match "([a-fA-F0-9:]+:[a-fA-F0-9:]+)") {
                Write-Host "  Found AAAA record: $address"
                $record.AAAARecord = $address
            }
        } #>
    }
	
	Write-Host "  Performing www nslookup..."
    # Perform nslookup for A and AAAA records
    $nslookupResults = nslookup www.$domain
	$nslookupResults = $nslookupResults | Select-Object -Skip 2

    # Extract A and AAAA records
    foreach ($line in $nslookupResults) {
		Write-Host "Debug output"
		Write-Host $line
        if ($line -match "(\d+\.\d+\.\d+\.\d+)") {
			$address = $matches[1]
			Write-Host "  Found A record: $address"
			$record.WARecord = $address
		} elseif ($line -match "([a-fA-F0-9:]+:[a-fA-F0-9:]+)") {
			$address = $matches[1]
			Write-Host "  Found AAAA record: $address"
			$record.WAAAARecord = $address
		}
		
<#         if ($line -match "Address: (.*)") {
            $address = $matches[1]
            # Determine if the address is IPv4 (A record) or IPv6 (AAAA record)
            if ($address -match "\d+\.\d+\.\d+\.\d+") {
                Write-Host "  Found A record: $address"
                $record.ARecord = $address
            } elseif ($address -match "([a-fA-F0-9:]+:[a-fA-F0-9:]+)") {
                Write-Host "  Found AAAA record: $address"
                $record.AAAARecord = $address
            }
        } #>
    }

    # Add the record to the results array
    $results += $record
}

Write-Host "Exporting results to CSV..."
# Export the results to a CSV file
$results | Export-Csv -NoTypeInformation -Path $outputCsvPath

Write-Host "Script completed. Check $outputCsvPath for output."

# End of script