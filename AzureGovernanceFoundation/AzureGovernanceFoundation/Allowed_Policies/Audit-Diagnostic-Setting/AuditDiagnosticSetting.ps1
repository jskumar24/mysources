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
    [string] $definitionAuditDiagnosticSetting
)

# Authenticate to Azure
Login-AzureRmAccount

# Select an subscription
$defaultSubscriptionId = (Get-AzureRmSubscription | Out-GridView -Title "Mashreq Cloud" -PassThru).SubscriptionId
Write-Host "You have choosen the subscription " + $defaultSubscriptionId
Write-Host "'n"
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

############### Get list of not allowed resource types ####################################
$allowedRTList = @{ }
Try {
    $TagsFilePath = $ScriptDirectory + '\Audit-Diagnostic-Setting.csv'
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
    $allowedRTList = $returnResults.Trim()
    $ObjAllowedResourceTypeLists = '{"listOfResourceTypes":{"value":[' + $allowedRTList + ']}}'
} 
Catch {
    Write-Verbose "Failed to read from the CSV file $TagsFilePath Exiting!"
    Break
}

############### Create the Policy Definition (Subscription scope) #####################
# Create allowed resource types definition
$definitionAuditDiagnosticSetting = New-AzureRmPolicyDefinition `
    -Name "MashreqAuditDiagnosticSetting" `
    -DisplayName "Mashreq Audit Diagnostic Setting allowed to resource types" `
    -description "This policy enables you to specify the resource types that your organization can deploy." `
    -Policy $ScriptDirectory\azurepolicy.rules.json `
    -Parameter $ScriptDirectory\azurepolicy.parameters.json `
    -Mode All

############## Apply the Policy Definition to a specific definition #####################
# Apply the Policy Definition of Allowed Resource Types
$allowedAuditDiagnosticSettingPolicy = Get-AzureRmPolicyDefinition `
    -Name MashreqAuditDiagnosticSetting
New-AzureRmPolicyAssignment `
    -Name "MashreqAuditDiagnosticSetting" `
    -PolicyParameter $ObjAllowedResourceTypeLists `
    -PolicyDefinition $allowedAuditDiagnosticSettingPolicy `
    -Scope /subscriptions/$defaultSubscriptionId
#>
# Destory the local variables 
$definitionAuditDiagnosticSetting = @{ } 
$allowedAuditDiagnosticSettingPolicy = @{ }
$ObjAllowedResourceTypeLists = @{ }