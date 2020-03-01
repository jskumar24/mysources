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
    [string] $ScriptDirectory, 
    # allowed resource types definition
    [string] $definitionhttpsTrafficStorageAccount
)

# Authenticate to Azure
Login-AzureRmAccount

# Select an subscription
$defaultSubscriptionId = (Get-AzureRmSubscription | Out-GridView -Title "Cloud Practice StaaS ( 201473 )" -PassThru).SubscriptionId
Write-Host "You have choosen the subscription " + $defaultSubscriptionId
Write-Host "'n"
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

############### Create the Policy Definition (Subscription scope) #####################
# Create allowed resource types definition
$definitionhttpsTrafficStorageAccount = New-AzureRmPolicyDefinition `
    -Name "MashreqEnsureHttpsTrafficOnlyForStorageAccount" `
    -DisplayName "Mashreq Ensure Https Traffic Only For Storage Account" `
    -description "Ensure https traffic only for storage account." `
    -Policy $ScriptDirectory\azurepolicy.rules.json `
    -Parameter $ScriptDirectory\azurepolicy.parameters.json `
    -Mode All

############## Apply the Policy Definition to a specific definition #####################
# Apply the Policy Definition of Allowed Resource Types
$allowedHttpsTrafficOnlyForStorageAccount = Get-AzureRmPolicyDefinition `
    -Name MashreqEnsureHttpsTrafficOnlyForStorageAccount
New-AzureRmPolicyAssignment `
    -Name "MashreqEnsureHttpsTrafficOnlyForStorageAccount" `
    -description "Ensure https traffic only for storage account." `
    -PolicyDefinition $allowedHttpsTrafficOnlyForStorageAccount `
    -Scope /subscriptions/$defaultSubscriptionId
#>
# Destory the local variables 
$definitionhttpsTrafficStorageAccount = @{ } 
$allowedHttpsTrafficOnlyForStorageAccount = @{ } 