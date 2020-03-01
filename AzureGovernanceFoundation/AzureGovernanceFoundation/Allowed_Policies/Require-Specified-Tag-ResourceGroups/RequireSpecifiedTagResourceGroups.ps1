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
    [string] $definitionRequireTag
)

# Authenticate to Azure
Login-AzureRmAccount

# Select an subscription
$defaultSubscriptionId = (Get-AzureRmSubscription | Out-GridView -Title "Mashreq Cloud" -PassThru).SubscriptionId
Write-Host "You have choosen the subscription " + $defaultSubscriptionId
Write-Host "'n"
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

############### Get list of not allowed resource types ####################################
Try {
    $TagsFilePath = $ScriptDirectory + '\Allowed_Tags.csv'
    $CSVData = @(Import-CSV -Path $TagsFilePath -ErrorAction Stop)
    Write-Verbose "Successfully imported entries from $TagsFilePath"
    Write-Verbose "Total no. of entries in CSV are : $($CSVData.count)"
    
    Foreach ($Entry in $CSVData) {
        Try { 
            # Verify that mandatory properties are defined for each object
            $AppliedTag = $Entry.RequireTags
            if (!([string]::IsNullOrEmpty($AppliedTag))) {
                $defName = $AppliedTag.Trim()
                $defName = $defName -replace (" ", "")
                $defName = "MashreqRequire" + $defName + "TagOnResourceGroup"
                $defDisplayName = "Mashreq Require " + $AppliedTag + " Tag on Resource Group"
                $defDescription = "Required the following tags for Billing Purpose." + "`n" + $AppliedTag  
                $ObjAllowedResourceTypeLists = "{" + "`n" + """tagName"": {" + "`n" + """value"": " + "`n" + """" + $AppliedTag + """" + "`n" + "}" + "`n" + "}"  

                ############### Create the Policy Definition (Subscription scope) #####################
                # Create allowed resource types definition
                $definitionRequireTag = New-AzureRmPolicyDefinition `
                    -Name $defName `
                    -DisplayName $defDisplayName `
                    -description $defDescription `
                    -Policy $ScriptDirectory\azurepolicy.rules.json `
                    -Parameter $ScriptDirectory\azurepolicy.parameters.json `
                    -Mode All

                ############## Apply the Policy Definition to a specific definition #####################
                # Apply the Policy Definition of Allowed Resource Types
                $RequireTagPolicy = Get-AzureRmPolicyDefinition `
                    -Name $defName
                New-AzureRmPolicyAssignment `
                    -Name $defName `
                    -PolicyParameter $ObjAllowedResourceTypeLists `
                    -PolicyDefinition $RequireTagPolicy `
                    -Scope /subscriptions/$defaultSubscriptionId
            }
        }
        Catch {
            Write-Error "$AppliedTag : Error occurred while creating Azure Resource Group."
        }
        Finally {
        }
    }
} 
Catch {
    Write-Verbose "Failed to read from the CSV file $TagsFilePath Exiting!"
    Break
}

#>
# Destory the local variables 
$definitionRequireTag = @{ } 
$RequireTagPolicy = @{ }
$ObjAllowedResourceTypeLists = @{ }