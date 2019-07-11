Import-Module AzureRM.Profile
Import-Module AzureRm.PowerBiEmbedded
Import-Module AzureRm.Automation

$SKU = Get-AutomationVariable -Name 'SKUUp'
$ApplicationId = Get-AutomationVariable -Name 'ApplicationId'
$TenantId = Get-AutomationVariable -Name 'TenantId'
$password = Get-AutomationVariable -Name 'password'
$capacityname = Get-AutomationVariable -Name 'capacityname'
$rgname = Get-AutomationVariable -Name 'rgname'

$passwd = ConvertTo-SecureString $password -AsPlainText -Force
$pscredential = New-Object System.Management.Automation.PSCredential($ApplicationId, $passwd)

$weekday = ( get-date ).DayOfWeek.value__
$ValidDays = @(1,2,3,4,5)
Write-Output 'El dia de la semana es '$weekday

if ($weekday -in $ValidDays) {
	 Write-Output 'Weekday, Debemos escalar '$capacityname' a '$SKU

	 Connect-AzureRmAccount `
			 -ServicePrincipal `
			 -Credential $pscredential `
			 -TenantId $TenantId

	 Update-AzureRmPowerBIEmbeddedCapacity `
			 -Name $capacityname `
			 -PassThru `
			 -Sku $SKU `
			 -ResourceGroupName $rgname

	 Get-AzureRmPowerBIEmbeddedCapacity `
			 -ResourceGroupName $rgname `
			 -Name $capacityname
}
else {
	 Write-Output 'Es fin de semana, no escalamos'
}
