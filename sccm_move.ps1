#Powershell script to facilitate a move of a server(s) linked to a cloud platform to different AD groups both new and exisitng.


[CmdletBinding()]
Param(
    [Parameter(Mandatory= $true)]
    [string]$CsvFilePath
)

#Import Active Directory Module
Write-Host "Importing Module...."
Import-Module ActiveDirectory

#Check if source exists and if file specified is a CSV file
if(Test-Path -path $CsvFilePath)
{
    if(!([System.IO.Path]::GetExtension($CsvFilePath) -eq ".csv"))
    {
        Write-Error "Please ensure file sepcified is a CSV file"
    }
}

else{Write-Error "Path does not exist. Please check file path is valid and try again"}

#Create Destination File
$sccm_report = Split-Path -Path $CsvFilePath
$CsvFileNoExtension = [System.IO.Path]::GetFileNameWithoutExtension($CsvFilePath)
$CsvExtension = [System.IO.Path]::GetExtension($CsvFilePath)
$Destination = "$sccm_report\" + $CsvFileNoExtension + "_" + $(Get-Date -Format 'yyyyMMdd_HHmmss') + $CsvExtension
Write-Host "Destination file $Destination has been created"

#Retrieve and open CSV file
Write-Host "Importing Csv file ... "
$csv = Import-CSV -Path $CsvFilePath

#Add property for success tracking
$csv | Add-Member -Name 'Success' -MemberType 'NoteProperty' -Value $false -Force | Out-Null
Write-Host "Property has been created"

#Loop through the Name and patch group
foreach ($vm in $csv)
{
    $csvPatchValue = $vm.patchGroup
    $serverName = $vm.name
    try{

        $ad_patchValue = Get-ADGroup -Identity $csvPatchValue #get the adgroup object from the CSV
        $ad_computerValue = Get-ADComputer -Identity $serverName #get the server name object from the CSV
        $ad_patchAccount = $ad_patchValue.SamAccountName
        $ad_serverAccount = $ad_computerValue.SamAccountName
        Add-ADGroupMember -Identity $ad_patchAccount -Members $ad_serverAccount
        Write-Host " $($serverName) has been successfully added to $($csvPatchValue) group"
        $vm.success = $true
    }

    catch{
        Write-Warning "Server name $($serverName) or SCCM_group $($csvPatchValue) does not exist"
    }
    $vm | Export-Csv -Path $Destination -NoTypeInformation -Append
}

Write-Host "Done"