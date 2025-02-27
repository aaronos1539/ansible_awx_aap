## Import Ivanti Powershell module
Write-Host “Importing the Ivanti Powershell module...”
Import-Module STProtect –PassThru


 
## Start the NON-Prod scan
Write-Host “Scanning NON-Prod machine group...”
$ScanInfo = Start-PatchScan –MachineGroups “Sample Group” –TemplateName “Security Patch Scan” | Wait-PatchScan


 
## Deploy the missing patches
Write-Host “Deploying missing patches...”
Start-PatchDeploy –ScanUid ($ScanInfo.Uid) –TemplateName “Sample Deploy Template”
