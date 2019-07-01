#requires -version 5

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string] $vcenter = $(Read-Host -Prompt 'Enter a vCenter hostname or IP to connect to:'), #Enter Vcenter to connect to
    [Parameter(Mandatory = $true)]
    [pscredential] $Creds = $(Get-Credential -message "Enter credentials for vCenter: "),#pop up screen for credential
    [Parameter(Mandatory = $true)]
    [string]$Datacenter = $(Read-Host -Prompt  'Enter the DataCenter where the VM(s) is hosted:'), #Enter Datacenter
    [int]$waittime = 200 #Seconds
)

$Title = "ShutDown VMs in Datacenter"
$ScriptInfo =  @("
Title: $Title
Purpose: Purpose of this script is to shutdown all servers in a datacenter 
Produced: 10/12/2017
Version: 1.0
Author: Stephen Oluwaniyi
Prerequisites: You should know the datacenter where the VMs are hosted. If unknown, this script will fail. Ensure the right datacenter is selected as running this script will potentially bring all the VMs down in a datacenter!
")

# Display confirmation box
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")| out-null
$Confirmation= [System.Windows.Forms.MessageBox]::Show(
"$ScriptInfo
Do you wish to continue?" , "Readme" , 4
)
if ($Confirmation -eq "NO" ){Write-Host "Script terminated by user." ; Break}

#Connect to the vCenter
Connect-VIServer $vcenter -Credential $Creds


# Get All the VMs in the Datacenter
$TargetDatacenter = Get-Datacenter | Where-Object {$_.Name -imatch $Datacenter}
$VMs = $TargetDatacenter | Get-VM 
$TotalVMs = $VMs.count 
$counter = 0
 

#Get Hosts within Datacenter
$ESXSRV = $TargetDatacenter | Get-VMHost


# For each of the VMs on the ESX hosts
Foreach ($VM in $VMs){
    $counter++
    # Shutdown the guest cleanly
    Write-Host "Shutting down $($VM.Name)..($counter of $TotalVMs)"
    $VM | Shutdown-VMGuest -Confirm:$false

   #Wait for Shutdown to complete
   do {
      #Wait 5 seconds
      Start-Sleep -s 5
      #Check the power status
      Write-Host "Checking Power status of $vm ..."
      $MyVM = Get-VM -Name $VM
      $status = $MyVM.PowerState
   }until($status -eq "PoweredOff")
}
 
$Time = (Get-Date).TimeofDay
do {
    # Wait for the VMs to be Shutdown cleanly
    Write-Host "Confirming all VMs have been shutdown..."
    Start-Sleep 1.0
    $timeleft = $waittime - ($Newtime.seconds)
    $numvms = ($TargetDatacenter | Get-VM | Where-Object { $_.PowerState -eq "poweredOn" }).Count
    Write-Host "Waiting for shutdown of $numvms VMs or until $timeleft seconds"
    $Newtime = (Get-Date).TimeofDay - $Time
    } until ((@($TargetDatacenter | Get-VM | Where-Object { $_.PowerState -eq "poweredOn" }).Count) -eq 0 -or ($Newtime).Seconds -ge $waittime)
    Write-Host "All VMs have been successfully shutdown!"
 
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")| out-null
[System.Windows.Forms.MessageBox]::Show(
"All VMS have been shutdown you can proceed to shut off the ESX hosts in datacenter(s): $TargetDatacenter" , "Readme" , 0
)

