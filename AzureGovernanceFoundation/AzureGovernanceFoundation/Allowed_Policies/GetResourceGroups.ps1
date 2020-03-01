# begin

function GetResourceGroups() { 
    
	$password = ConvertTo-SecureString 'Jradha3#' -AsPlainText -Force
	$credential = New-Object System.Management.Automation.PSCredential ('sathish@virtusacloudstaas.onmicrosoft.com', $password)
	Connect-AzureRmAccount -Credential $Credential -Subscription 419fc527-9b96-42c1-8151-477ef2bcd158 -Tenant 0b97c5d2-2b9a-4dd2-8074-7298f9d603b5 | Out-Null
	
	$ResourceGroups = Get-AzureRmResourceGroup
	$Resources = New-Object System.Collections.ArrayList 
	foreach ($ResourceGroup in $ResourceGroups) {     
		$Resources += $ResourceGroup.ResourceGroupName + ","
	}
	return $Resources
} 

GetResourceGroups
# end