# begin

function GetPolicyDisplayName() { 
    
    # $password = ConvertTo-SecureString 'Jradha3#' -AsPlainText -Force
    # $credential = New-Object System.Management.Automation.PSCredential ('sathish@virtusacloudstaas.onmicrosoft.com', $password)
    # Connect-AzureRmAccount -Credential $Credential -Subscription 419fc527-9b96-42c1-8151-477ef2bcd158 -Tenant 0b97c5d2-2b9a-4dd2-8074-7298f9d603b5
    Login-AzureRmAccount | Out-Null
    $LoginSubScriptonName = New-Object System.Collections.ArrayList 
    $LoginSubScriptonName += Get-AzureRmSubscription | Select-Object -Property Name
    return $LoginSubScriptonName
} 

GetPolicyDisplayName
# end