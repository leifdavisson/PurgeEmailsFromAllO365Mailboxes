Set-PSDebug -off
Clear-Host 
Write-Host "`r`n You will need to login twice with appropreate credentials."
# users need to have eDiscovery Admin, and Organizational Admin. 
Write-Host "`r`n Installing Module... Please wait."
Import-Module ExchangeOnlineManagement -force
Write-Host "`r`n Updating Module... Please wait."
Update-Module ExchangeOnlineManagement -force
Connect-ExchangeOnline
Connect-IPPSSession
$Sname = Read-Host "`r`n Name your Search(NO SPACES)"
$Sfrom = Read-Host "`r`n Enter senders email address(NO SPACES)"
$Sfrom = $Sfrom.Trim()
$Sname = $Sname.Trim()
New-ComplianceSearch -Name $Sname -ExchangeLocation All -ContentMatchQuery "from:$Sfrom"
Start-ComplianceSearch $Sname
get-ComplianceSearch $Sname |Format-List 
#TO DO: write loop to read search output until its not in progress. 
write-host "Wait 30 minutes for Search to complete." 
start-sleep -seconds 1800

$Syn = Read-Host "`r`n Reveiew report above. Look for the Items field and verify the count is correct. `r`n `r`n Are you sure you want to purge this email? Y OR N"
if ( $Syn -eq 'Y' ){
    #New-ComplianceSearchAction -SearchName $Sname -Purge -PurgeType SoftDelete
    }Else{ 
        Write-host ("Email were not deleted.")
        }
Write-Host  "Waiting for purge to complete." 
start-sleep -seconds 1800

Get-ComplianceSearchAction
$Syn = Read-Host "`r`n View Purge Report? Y OR N"
if ( $Syn -eq 'Y' ){
	Get-ComplianceSearchAction -SeachName $Sname | Format-List 
    }Else{ 
        Clear-Host; Write-host ("Program completed.")
        }
