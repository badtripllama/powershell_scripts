<#
 This PowerShell script will prompt you for:                                
    * Admin credentials for a user who can run the Get-MailboxFolderStatistics cmdlet in Exchange    
      Online and who is an eDiscovery Manager in the compliance portal.            
 The script will then:                                            
    * If an email address is supplied: list the folders for the target mailbox.            
                                 
    * The script supplies the correct search properties (folderid: or documentlink:)    
      appended to the folder ID or documentlink to use in a Content Search.                
 Notes:                                                                      
    * For Exchange, only the specified folder will be searched; this means sub-folders in the folder    
      will not be searched.  To search sub-folders, you need to use the specify the folder ID for    
      each sub-folder that you want to search.                                
    * For Exchange, only folders in the user's primary mailbox will be returned by the script.        
#>
# Collect the target email address
$address = Read-Host "Enter an email address"

# Authenticate with Exchange Online and the compliance portal (Exchange Online Protection - EOP)

if ($address.IndexOf("@") -ige 0)
{
   # List the folder Ids for the target mailbox
   $emailAddress = $address
   # Connect to Exchange Online PowerShell
   if (!$ExoSession)
   {
       Import-Module ExchangeOnlineManagement
       Connect-ExchangeOnline -ShowBanner:$false -CommandName Get-MailboxFolderStatistics
   }
   $folderQueries = @()
   $folderStatistics = Get-MailboxFolderStatistics $emailAddress
   foreach ($folderStatistic in $folderStatistics)
   {
       $folderId = $folderStatistic.FolderId;
       $folderPath = $folderStatistic.FolderPath;
       $encoding= [System.Text.Encoding]::GetEncoding("us-ascii")
       $nibbler= $encoding.GetBytes("0123456789ABCDEF");
       $folderIdBytes = [Convert]::FromBase64String($folderId);
       $indexIdBytes = New-Object byte[] 48;
       $indexIdIdx=0;
       $folderIdBytes | select -skip 23 -First 24 | %{$indexIdBytes[$indexIdIdx++]=$nibbler[$_ -shr 4];$indexIdBytes[$indexIdIdx++]=$nibbler[$_ -band 0xF]}
       $folderQuery = "folderid:$($encoding.GetString($indexIdBytes))";
       $folderStat = New-Object PSObject
       Add-Member -InputObject $folderStat -MemberType NoteProperty -Name FolderPath -Value $folderPath
       Add-Member -InputObject $folderStat -MemberType NoteProperty -Name FolderQuery -Value $folderQuery
       $folderQueries += $folderStat
   }
   Write-Host "-----Exchange Folders-----"
   $folderQueries |ft
}

