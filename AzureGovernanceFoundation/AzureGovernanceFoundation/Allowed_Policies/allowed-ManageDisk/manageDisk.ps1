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
    [string] $definitionAllowManageDisk
)

# Authenticate to Azure
Login-AzureRmAccount

# Select an subscription
$defaultSubscriptionId = (Get-AzureRmSubscription | Out-GridView -Title "Mashreq Cloud" -PassThru).SubscriptionId
Write-Host "You have choosen the subscription " + $defaultSubscriptionId
Write-Host "'n"
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

############### Create the Policy Definition (Subscription scope) #####################
# Create allowed locations definition
$definitionAllowManageDisk = New-AzureRmPolicyDefinition `
    -Name "MashreqManagedDiskRestriction" `
    -DisplayName "MashreqManagedDiskRestriction" `
    -description "This policy forces the VM creation with Managed Disk Only." `
    -Policy $ScriptDirectory\azurepolicy.rules.json `
    -Parameter $ScriptDirectory\azurepolicy.parameters.json `
    -Mode All

############## Apply the Policy Definition to a specific definition #####################
# Apply the Policy Definition of Locations
$managedDiskPolicy = Get-AzureRmPolicyDefinition -Name MashreqManagedDiskRestriction
New-AzureRmPolicyAssignment `
    -Name "MashreqManagedDiskRestriction" `
    -PolicyDefinition $managedDiskPolicy `
    -description "This policy forces the VM creation with Managed Disk Only." `
    -Scope /subscriptions/$defaultSubscriptionId

# # Destory the local variables
$definitionAllowManageDisk = @{ }
$managedDiskPolicy = @{ }
