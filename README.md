## Export-AppServiceCertificate Script

App Service Certificates can be exported for use with other Azure resources using Azure PowerShell.

You can use the following PowerShell scripts to create a local PFX copy to use these certificates outside of App Service platform, like with Azure Virtual Machines.

Before making a local copy, make sure that: 

1. You need the Global administrator role assigned to you
2. The App Service Certificate is in ‘Issued’ state
3. You need to install Azure PowerShell and have the required modules installed.


### Export-AppServiceCertificate_v1.ps1

The **Export-AppServiceCertificate_v1.ps1** was made for use with AzureRM PowerShell cmdlets.  AzureRM PowerShell requires PowerShell version 5.0. You can find a guide of how to install AzureRM PowerShell in the links below:

- https://docs.microsoft.com/en-us/powershell/azure/azurerm/install-azurerm-ps?view=azurermps-6.13.0
- https://www.jgspiers.com/how-to-connect-to-azure-powershell-arm-azuread/

To use the script, copy the entire script, open the Windows PowerShell ISE and paste it on the PowerShell window. You can run the commands line-by-line or first run the Login-AzureRmAccount cmd and then run the entire script (excluding the Login cmd).


### Export-AppServiceCertificate_v2.ps1

The **Export-AppServiceCertificate_v2.ps1** was made for use with Az PowerShell cmdlets.  PowerShell 7.0.6 LTS, PowerShell 7.1.3, or higher is the recommended version of PowerShell for use with the Azure Az PowerShell. You can find a guide of how to install Az PowerShell in the link below:

- https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-6.5.0


To use the script, copy the entire script, open the Windows PowerShell 7 with Visual Studio Code (or other code editor) and paste it on the editor window. You can run the commands line-by-line or first run the Connect-AzAccount cmd and then run the entire script (excluding the Connect cmd).
