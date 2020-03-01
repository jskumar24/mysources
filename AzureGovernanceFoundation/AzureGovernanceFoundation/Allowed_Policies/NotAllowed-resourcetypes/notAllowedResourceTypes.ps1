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
    # not allowed resource types definition
    [string] $definitionNotAllowResourceTypes
)

# Authenticate to Azure
Login-AzureRmAccount

# Select an subscription
$defaultSubscriptionId = (Get-AzureRmSubscription | Out-GridView -Title "Cloud Practice StaaS ( 201473 )" -PassThru).SubscriptionId
Write-Host "You have choosen the subscription " + $defaultSubscriptionId
Write-Host "'n"
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

############### Get list of not allowed resource types ####################################
$notAllowedRTList = @{ }
Try {
    $TagsFilePath = $ScriptDirectory + '\Not_Allowed_ResourcTypes.csv'
    $CSVData = @(Import-CSV -Path $TagsFilePath -ErrorAction Stop)
    Write-Verbose "Successfully imported entries from $TagsFilePath"
    Write-Verbose "Total no. of entries in CSV are : $($CSVData.count)"
    $returnResults = @{ } 
    $GetType = @{ }
    Foreach ($Entry in $CSVData) {
        Try { 
            # Verify that mandatory properties are defined for each object
            $ResourceType = $Entry.ResourceTypes
            $GetResource = Get-AzureRmResourceProvider -ProviderNamespace $ResourceType
            $GetResourceTypes = $GetResource.ResourceTypes
        
            foreach ($type in $GetResourceTypes) { 
                if ($GetType.Count -eq 0) { 
                    $GetType = """" + $ResourceType + "/" + $type.ResourceTypeName + """" + "," 
                }
                else {
                    $GetType = $GetType + """" + $ResourceType + "/" + $type.ResourceTypeName + """" + ","  
                } 
            }
            
        }
        Catch {
            Write-Error "$ResourceType : Error occurred while creating Azure Resource Type."
        }
        Finally {

        }
    }
    $returnResults = $GetType.Trim()
    $returnResults = $returnResults.Substring(0, $returnResults.Length - 1)
    $notAllowedRTList = $returnResults.Trim()
    $ObjNotAllowedResourceTypeLists = '{"listOfResourceTypesNotAllowed":{"value":[' + $notAllowedRTList + ']}}'
} 
Catch {
    Write-Verbose "Failed to read from the CSV file $TagsFilePath Exiting!"
    Break
}

############### Create the Policy Definition (Subscription scope) #####################
# Create allowed resource types definition
$definitionNotAllowResourceTypes = New-AzureRmPolicyDefinition `
    -Name "MashreqNotAllowedResourceTypes" `
    -DisplayName "Mashreq Not Allowed resource types" `
    -description "This policy enables you to specify the resource types that your organization can deploy." `
    -Policy $ScriptDirectory\azurepolicy.rules.json `
    -Parameter $ScriptDirectory\azurepolicy.parameters.json `
    -Mode All

############## Apply the Policy Definition to a specific definition #####################
# Apply the Policy Definition of Not Allowed Resource Types
$NotAllowedResourceTypePolicy = Get-AzureRmPolicyDefinition `
    -Name MashreqNotAllowedResourceTypes
New-AzureRmPolicyAssignment `
    -Name "Mashreq Not Allowed Resource Types" `
    -description "This policy enables you to specify the resource types that your organization can deploy." `
    -PolicyParameter $ObjNotAllowedResourceTypeLists `
    -PolicyDefinition $NotAllowedResourceTypePolicy `
    -Scope /subscriptions/$defaultSubscriptionId

# # Destory the local variables  
$defaultSubscriptionId = @{ }
$definitionNotAllowResourceTypes = @{ }  
$NotAllowedResourceTypePolicy = @{ }
$ObjNotAllowedResourceTypeLists = @{ }