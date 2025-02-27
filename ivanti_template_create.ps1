############################### Begin - Creates the Patch Scan Template ##############################
function SetPatchTemplate 
{
    # Things to exclude
    Write-Host "`t-Getting Vendors to Include..."
    $Included_Vendors = (Get-VendorFamilyProductHierarchy | Select-Object -Property name, id | Where-Object {`
           ($_.name -ne 'Apache Software Foundation')`
      -and ($_.name -ne 'Citrix')`
      -and ($_.name -ne 'Hewlett-Packard')`
      -and ($_.name -ne 'Skype Technologies S.A.')`
      -and ($_.name -ne 'Sun Microsystems')`
      -and ($_.name -ne 'Tableau Software')`
      -and ($_.name -ne 'Amazon Services LLC')`
      -and ($_.name -ne 'WinSCP')`
      -and ($_.name -ne 'AdoptOpenJDK')`
      -and ($_.name -ne 'Eclipse Foundation')`
      -and ($_.name -ne 'Microsoft')}).id
    Write-Host "`t-Getting Microsoft Families to Include..."
    $Included_Microsoft_Families = (Get-VendorFamilyProductHierarchy | Where-Object {$_.name -EQ 'Microsoft'} | select -ExpandProperty families | Where-Object {
           ($_.name -ne 'Exchange Server')`
      -and ($_.name -ne 'Exchange System Manager')`
      -and ($_.name -ne 'Live Messenger')`
      -and ($_.name -ne 'Lync')`
      -and ($_.name -ne 'Lync Server')`
      -and ($_.name -ne 'SharePoint')`
      -and ($_.name -ne 'SQL Server')`
      -and ($_.name -ne 'ODBC Driver for SQL Server')`
      -and ($_.name -ne 'OLE DB Driver for SQL Server')`
      -and ($_.name -ne 'System Center Operations Manager Agent')`
      -and ($_.name -ne 'System Center Operations Manager Audit Collection Server')`
      -and ($_.name -ne 'System Center Operations Manager Console')`
      -and ($_.name -ne 'System Center Operations Manager Gateway')`
      -and ($_.name -ne 'System Center Operations Manager Reporting')`
      -and ($_.name -ne 'System Center Operations Manager Server')`
      -and ($_.name -ne 'System Center Operations Manager Web Console')`
      -and ($_.name -ne 'System Center Virtual Machine Manager')`
      -and ($_.name -ne 'Systems Management Server')`
      -and ($_.name -ne 'WSUS')`
      -and ($_.name -ne '.Net')}).id
    Write-Host "`t-Getting DotNet products to Include..."
    $DotNet_Products = (Get-VendorFamilyProductHierarchy | Where-Object {$_.name -EQ 'Microsoft'}).families | where -Property name -EQ '.Net'
    $Dot_Items = ($DotNet_Products.products | Where-Object {
           ($_.name -ne '.NET 6.0')`
      -and ($_.name -ne '.NET 7.0')`
      -and ($_.name -ne '.NET Core 1.0')`
      -and ($_.name -ne '.NET Core 1.1')`
      -and ($_.name -ne '.NET Core 2.0')`
      -and ($_.name -ne '.NET Core 2.1')`
      -and ($_.name -ne '.NET Core 2.2')`
      -and ($_.name -ne '.NET Core 3.0')`
      -and ($_.name -ne '.NET Core 3.1')`
      -and ($_.name -ne '.NET Core 5.0')}).id
    Write-Host "`t-Creating the Patch Scan Template..."
    $vendorFamilyProductFilter = New-VendorFamilyProductFilter -IncludeVendors $Included_Vendors -IncludeFamilies $Included_Microsoft_Families -IncludeProducts $Dot_Items
    $patchPropertyFilter = New-PatchPropertyFilter -SecurityPatches Critical, Important, Moderate, Low, Unassigned -NonSecurityPatches Critical, Important, Moderate
    $patchFilter = New-PatchFilter -PatchGroupFilterType None -PatchPropertyFilter $patchPropertyFilter -VendorFamilyProductFilter $vendorFamilyProductFilter
    $PSTname = Get-PatchScanTemplate -Name $Patch_Scan_Template_Name
    Set-PatchScanTemplate -Template $PSTname -PatchFilter $patchFilter -Verbose
}

## Checking if the Patch Template already exsits
$Patch_Scan_Template_Status = Get-PatchScanTemplate | Where-Object -Property Name -EQ $Patch_Scan_Template_Name
if ($Patch_Scan_Template_Status) {
    Write-Host "`t-Setting up Template..."
    SetPatchTemplate
} else {
    Write-Host "`t-Creating New Template..."
    New-PatchScanTemplate -Name $Patch_Scan_Template_Name
    Write-Host "`t-Setting up Template..."
    SetPatchTemplate
}
############################### End --- Creates the Patch Scan Template ##############################
