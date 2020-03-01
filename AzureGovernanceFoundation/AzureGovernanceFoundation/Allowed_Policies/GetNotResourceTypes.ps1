# ******************************************************
# * Author  :   Sathish Kumar Janjirala   
# * Date    :   07-03-2019
# * Purpose :   Create Resource groups with Tags, Virtual Network and Subnets.
# ******************************************************
function GetAllResourceTypes() {
    Try {
        $TagsFilePath = 'C:\Sathish\Cloud Projects\Mashreq\Powershell_Scripts\Allowed_Policies\NotAllowed-resourcetypes\Not_Allowed_ResourcTypes.csv'
        $CSVData = @(Import-CSV -Path $TagsFilePath -ErrorAction Stop)
        Write-Verbose "Successfully imported entries from $TagsFilePath"
        Write-Verbose "Total no. of entries in CSV are : $($CSVData.count)"
    } 
    Catch {
        Write-Verbose "Failed to read from the CSV file $TagsFilePath Exiting!"
        Break
    }

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
                    $GetType = """" + $ResourceType + "/" + $type.ResourceTypeName + """" + "`n"
                }
                else {
                    $GetType = $GetType + """" + $ResourceType + "/" + $type.ResourceTypeName + """" + "`n"
                } 
            }        
            $returnResults = $GetType + "`n"
            # Write-Host "$ResourceType : Resource Type is capture successfully!"
        }
        Catch {
            Write-Error "$ResourceGroup : Error occurred while creating Azure Resource Group."
        }
        Finally {

        }
    }
    return $returnResults
} 