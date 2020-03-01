# ******************************************************
# * Author  : Sathish Kumar Janjirala  
# * Date    : 05-05-2019    
# * Purpose : Create the policies for subscrition level.
# ******************************************************

# Delcare the parameters
[CmdletBinding()]
param (
    # Enter into Specified Subscription.
    [string] $defaultSubscriptionId,
    # ResourceGroup to operate on. 
    [string] $sourcefilepath,
    # Location Name to operate on.
    [string] $Location,
    # Customer Name to operate on.
    [string] $CustomerName,
    # allowed locations definition
    [string] $definitionAllowLocation,
    # allowed resource types definition
    [string] $definitionAllowResourceTypes,
    # enforce resourceGroup tags definition
    [string] $definitionAllowEnforceTag,
    # Policy Definition of Locations
    [string] $locationPolicy,
    # Policy Definition of Enforce Tag
    [string] $enforceTagPolicy,
    [string] $matchPatternPolicy,
    [string] $definitionEnforcematchpattern,
    [string] $definitionNotAllowResourceTypes
)

# Authenticate to Azure
Login-AzureRmAccount

# Select an subscription
$defaultSubscriptionId = (Get-AzureRmSubscription | Out-GridView -Title "Cloud Practice StaaS ( 201473 )" -PassThru).SubscriptionId
Write-Host "You have choosen the subscription " + $defaultSubscriptionId
Write-Host "'n"
$sourcefilepath = 'C:\Sathish\Cloud Projects\Mashreq\Powershell_Scripts\Allowed_Policies'

############### Create the Policy Definition (Subscription scope) #####################
# Create allowed naming conventions - Match pattern
$definitionEnforcematchpattern = New-AzureRmPolicyDefinition -Name "MashreqEnforceMatchPattern" `
    -DisplayName "Mashreq Enforce Like Pattern" `
    -description "Enforce a naming pattern on resources with the match condition." `
    -Policy $sourcefilepath\allowed-NamingConvention\azurepolicy.rules.json `
    -Parameter $sourcefilepath\allowed-NamingConvention\azurepolicy.parameters.json `
    -Mode All
<#
# Create allowed locations definition
$definitionAllowLocation = New-AzureRmPolicyDefinition `
    -Name "MashreqAllowedLocations" `
    -DisplayName "Mashreq Allowed locations" `
    -description "This policy enables you to restrict the locations your organization can specify when deploying resources." `
    -Policy $sourcefilepath\allowed-locations\azurepolicy.rules.json `
    -Parameter $sourcefilepath\allowed-locations\azurepolicy.parameters.json `
    -Mode All

# Create allowed resource types definition
$definitionAllowResourceTypes = New-AzureRmPolicyDefinition `
    -Name "MashreqAllowedResourceTypes" `
    -DisplayName "Mashreq Allowed resource types" `
    -description "This policy enables you to specify the resource types that your organization can deploy." `
    -Policy $sourcefilepath\allowed-resourcetypes\azurepolicy.rules.json `
    -Parameter $sourcefilepath\allowed-resourcetypes\azurepolicy.parameters.json `
    -Mode All

# Create allowed resource types definition
$definitionNotAllowResourceTypes = New-AzureRmPolicyDefinition `
    -Name "MashreqNotAllowedResourceTypes" `
    -DisplayName "Mashreq Not Allowed resource types" `
    -description "This policy enables you to specify the resource types that your organization can deploy." `
    -Policy $sourcefilepath\Notallowed-resourcetypes\azurepolicy.rules.json `
    -Parameter $sourcefilepath\Notallowed-resourcetypes\azurepolicy.parameters.json `
    -Mode All
#>
############## Apply the Policy Definition to a specific definition #####################
# Apply the Policy Definition of naming conventions - Match pattern
# $namePattern = 'AZ-MB-UAEN'
$matchPatternPolicy = Get-AzureRmPolicyDefinition `
    -Name MashreqEnforceMatchPattern
New-AzureRmPolicyAssignment -Name "Mashreq Enforce Match Pattern" `
    -PolicyDefinition $matchPatternPolicy `
    -Scope /subscriptions/$defaultSubscriptionId
<#
# Apply the Policy Definition of Locations
$locationPolicy = Get-AzureRmPolicyDefinition `
    -Name MashreqAllowedLocations
New-AzureRmPolicyAssignment `
    -Name "Mashreq Permitted Locations" `
    -PolicyParameter $sourcefilepath\allowed-locations\allow.locations.json `
    -PolicyDefinition $locationPolicy `
    -Scope /subscriptions/$defaultSubscriptionId

# Apply the Policy Definition of Not Allowed Resource Types
$NotAllowedResourceTypePolicy = Get-AzureRmPolicyDefinition `
    -Name MashreqNotAllowedResourceTypes
New-AzureRmPolicyAssignment `
    -Name "Mashreq Not Allowed Resource Types" `
    -PolicyParameter $sourcefilepath\NotAllowed-resourcetypes\azureresourcetypenames.json `
    -PolicyDefinition $NotAllowedResourceTypePolicy `
    -Scope /subscriptions/$defaultSubscriptionId

# Apply the Policy Definition of Allowed Resource Types
$allowedResourceTypePolicy = Get-AzureRmPolicyDefinition `
    -Name MashreqAllowedResourceTypes
New-AzureRmPolicyAssignment `
    -Name "Mashreq Allowed Resource Types" `
    -PolicyParameter $sourcefilepath\allowed-resourcetypes\azureresourcetypenames.json `
    -PolicyDefinition $allowedResourceTypePolicy `
    -Scope /subscriptions/$defaultSubscriptionId
#>
# # Destory the local variables
$definitionAllowLocation = @{ }
$definitionAllowResourceTypes = @{ }
$definitionNotAllowResourceTypes = @{ }
$definitionAllowEnforceTag = @{ }
$locationPolicy = @{ }
# $enforceTagPolicy = @{}


