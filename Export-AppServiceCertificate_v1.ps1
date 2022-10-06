##Execute the command below to ensure that PowerShell version is 5:
$PSVersionTable.PSVersion

##Install AzureRM (You need elevated privileges to install modules from the PowerShell Gallery): 
Install-Module -Name AzureRM -AllowClobber
##Answer Yes or Yes to All to continue with the installation.

##If you already have the AzureRm installed on your system and get some error, try this:
    Set-PSRepository -Name PSGallery -SourceLocation https://www.powershellgallery.com/api/v2 -InstallationPolicy Trusted
    Register-PSRepository -Name PSGallery1 -SourceLocation https://www.powershellgallery.com/api/v2/ -InstallationPolicy Trusted
    Set-PSRepository -Name PSGallery -SourceLocation https://www.powershellgallery.com/api/v2/ -InstallationPolicy Trusted
    Update-Module -Name AzureRM

##PowerShell script execution policy must be set to remote signed:
set-executionpolicy remotesigned
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Load the latest version Azure PowerShell:
Import-Module -Name AzureRM

##Before starting, edit the fields below and check the information on README
$loginId = "Your login (prefer to use your User Principal Name)"
$subscriptionId = "Azure subscription ID"
$certResourceGroup = "Certificate Resource Group name"
$certName = "Certificate name created in App Service Certificates"

##Login and set the context
Login-AzureRmAccount
Set-AzureRmContext -SubscriptionId $subscriptionId

## Get the KeyVault Resource Url and KeyVault Secret Name were the certificate is stored
$resourceId = (Get-AzureRmResource -ResourceType Microsoft.CertificateRegistration/certificateOrders -Name $certName).ResourceId
$ascResource = Get-AzureRmResource -ResourceId $resourceId
$certProps = Get-Member -InputObject $ascResource.Properties.certificates[0] -MemberType NoteProperty
$certificateName = $certProps[0].Name
$keyVaultId = $ascResource.Properties.certificates[0].$certificateName.KeyVaultId
$keyVaultSecretName = $ascResource.Properties.certificates[0].$certificateName.KeyVaultSecretName

## Split the resource URL of KeyVault and get KeyVaultName and KeyVaultResourceGroupName
$keyVaultIdParts = $keyVaultId.Split("/")
$keyVaultName = $keyVaultIdParts[$keyVaultIdParts.Length - 1]
$keyVaultResourceGroupName = $keyVaultIdParts[$keyVaultIdParts.Length - 5]

## --- !! NOTE !! ----
## Only users who can set the access policy and has the the right RBAC permissions can set the access policy on KeyVault, if the command fails contact the owner of the KeyVault
Set-AzureRmKeyVaultAccessPolicy -ResourceGroupName $keyVaultResourceGroupName -VaultName $keyVaultName -UserPrincipalName $loginId -PermissionsToSecrets get
Write-Host "Get Secret Access to account $loginId has been granted from the KeyVault, please check and remove the policy after exporting the certificate"

## Getting the secret from the KeyVault
$secret = Get-AzureKeyVaultSecret -VaultName $keyVaultName -Name $keyVaultSecretName
$pfxCertObject= New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList @([Convert]::FromBase64String($secret.SecretValueText),"",[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
$pfxPassword = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 10 | % {[char]$_})
$currentDirectory = (Get-Location -PSProvider FileSystem).ProviderPath
[Environment]::CurrentDirectory = (Get-Location -PSProvider FileSystem).ProviderPath
[io.file]::WriteAllBytes("./$certName.pfx",$pfxCertObject.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12,$pfxPassword))

Write-Host "Created an App Service Certificate copy at: $currentDirectory\$certName.pfx"
Write-Host "PFX password: $pfxPassword"