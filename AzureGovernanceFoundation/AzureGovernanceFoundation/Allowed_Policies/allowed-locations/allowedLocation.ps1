
# ******************************************************
# * Author  : Sathish Kumar Janjirala
# * Date    : 05-05-2019
# * Purpose : Create the policies for subscrition level.
# ******************************************************


# Delcare the parameters
[CmdletBinding()]
param (    
    [Parameter(Mandatory = $True)]
    [string] $paraSubscriptionId,
    [Parameter(Mandatory = $True)]
    [string] $paraTenant,
    [Parameter(Mandatory = $True)]
    [string] $paraUsername,
    [Parameter(Mandatory = $True)]
    [string] $parapwd,
    [Parameter(Mandatory = $True)]
    [string] $paraPolicyName, 
    [Parameter(Mandatory = $True)]
    [string] $paraPolicyDisplayName,
    [Parameter(Mandatory = $True)] 
    [string] $paraPolicyDescription,
    [Parameter(Mandatory = $True)]
    [string] $paraTemplateRules,
    [Parameter(Mandatory = $True)]
    [string] $paraTemplateParameters,
    [Parameter(Mandatory = $True)]
    [string] $paraScope,
    [Parameter(Mandatory = $True)]
    [string] $paraParameterValues 
)

$password = ConvertTo-SecureString $parapwd -AsPlainText -Force

$credential = New-Object System.Management.Automation.PSCredential ($paraUsername, $password)

Connect-AzureRmAccount -Credential $credential -Subscription $paraSubscriptionId -Tenant $paraTenant

# Create the Policy Definition (Subscription scope)
$definition = New-AzureRmPolicyDefinition -Name $paraPolicyName -DisplayName $paraPolicyDisplayName -description $paraPolicyDescription -Policy $paraTemplateRules -Parameter $paraTemplateParameters -Mode Indexed

# Set the Policy Parameter (JSON format)
$policyparam = '{ "listOfAllowedLocations": { "value": [ ' + $paraParameterValues + ' ] } }'

$locationPolicy = Get-AzureRmPolicyDefinition -Name $paraPolicyName

# Create the Policy Assignment
$assignment = New-AzureRmPolicyAssignment -Name $paraPolicyName -DisplayName $paraPolicyDisplayName -Scope $paraScope -PolicyDefinition $locationPolicy -PolicyParameter $policyparam