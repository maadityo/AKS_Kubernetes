# Create variables to use in the lab
$WarningPreference = "SilentlyContinue"
$location = 'Southeast Asia'

#cd /home/mathias


$unicstr = -join ((97..122) | Get-Random -Count 5 | % {[char]$_})
$acrexists = $false
$dbexists = $false
$svcpexists = $false
$appexists = $false
$appdemoexists = $false
$kvexists = $false
$snrexists = $false
$devopsprojectexists = $false

Write-Host ''
Write-Host '---------------------------------------------------------------------------------------------------'
Write-Host 'If you already executed this script, go to https://portal.azure.com and delete old resources first'
Write-Host 'Delete as well DevSecOpsVariables on the Library in https://dev.azure.com'
Write-Host '---------------------------------------------------------------------------------------------------'
Write-Host ''
Write-Host 'A new window will open, please log in and go back here'
Write-Host ''
Write-Host 'Login in with your new accounr e.g. DevSecOpsYourName@outlook.com'
Write-Host 'in case of error in az cli, please re-install and re-open using the following command'
Write-Host ''
Write-Host "Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi'"


#$output = az Login
#if (!$output) {
#    Write-Error "Error validating the credentials"
#    return
#}

#$subscription = az account list --query --% "[?contains(name,'Maadityo') && contains(state,'Enabled')].[id]" -o tsv
$subscription='3975AF94-2757-46D8-ABE6-C8B5EC8C7D95'
#3975AF94-2757-46D8-ABE6-C8B5EC8C7D95
az account set --subscription $subscription

$a = az resource list --query --% "[?contains(name,'devsecops')].[name]" -o table
# To validate if the resource already exists
try 
{
    foreach ($item in $a) {
        $unicstr = $a[2].substring(9,5)
        switch ($item) {
            ("devsecops" + $unicstr + "acr"){ $acrexists = $true}
            ("devsecops" + $unicstr + "db"){ $dbexists = $true}
            ("devsecopsowasp" + $unicstr + "t10"){ $svcpexists = $true}
            ("devsecopsowaspapp" + $unicstr + "t10"){ $appexists = $true}
            ("devsecopsdemoapp" + $unicstr + "t10"){ $appdemoexists = $true}
            ("devsecops" + $unicstr + "akv"){ $kvexists = $true}
            ("devsecops" + $unicstr + "snr"){ $snrexists = $true}
        }
    }
    Write-Host 'Resources found in Azure: ' + $a
}
catch 
    {
        #Ignore this error
    }

$rgname = "devsecops-" + $unicstr + "-rg"
$acrname = "devsecops" + $unicstr + "acr"
$sqlsvname =  "devsecops" + $unicstr + "db"
$appServicePlan = "devsecopsowasp" + $unicstr + "t10"
$app = "devsecopsowaspapp" + $unicstr + "t10"
$appdemo = "devsecopsdemoapp" + $unicstr + "t10"
$keyvaultname = "devsecops" + $unicstr + "akv"
$sonarqaciname = "devsecops" + $unicstr + "snr"

$repomyclinic = 'MyHealthClinicSecDevOps-Public'

#Add DevOps Powershell Extention
az extension add --name azure-devops

#Configure local variables to call DevOps Services
$devopsservice = Read-Host -Prompt 'Type the URL DevOps with your organization e.g. : https://dev.azure.com/your_orgnization_name'
$devopspat = Read-Host -Prompt 'Enter Personal Token Access (PAT) created in the first part of requisites.'
$env:AZURE_DEVOPS_EXT_PAT = $devopspat

$a = az devops project list --organization $devopsservice --query value[].name -o tsv
# To validate if the resource already exists
try 
{
    foreach ($item in $a) {
        switch ($item) {
            ("devsecops"){ $devopsprojectexists = $true}
        }
    }
}
catch 
{
    Ignore this error
}

# register all providers from azure
Invoke-WebRequest 'https://dev.azure.com/SecureDevOpsDelivery/82dd0a19-ef30-4974-837a-b876e341813a/_apis/git/repositories/42215aa8-8ad3-4dbc-bd08-29ffc8c37e90/items?path=/provider-az.ps1&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=octetStream&api-version=5.0&download=true' -UseBasicParsing -OutFile '.\provider-az.ps1'

start powershell -windowstyle hidden .\provider-az.ps1

# Create a Key Vault to store secrets
Write-Host 'Creating DevSecOps project if not exists.....' 
if ($devopsprojectexists -eq $false)
{
    az devops project create --name "DevSecOps" --organization $devopsservice
}

az devops configure --defaults project="DevSecOps" organization=$devopsservice
	
Write-Host 'Downloading required lab files'
Invoke-WebRequest 'https://dev.azure.com/secureDevOpsDelivery/82dd0a19-ef30-4974-837a-b876e341813a/_apis/git/repositories/42215aa8-8ad3-4dbc-bd08-29ffc8c37e90/items?path=%2FBuildScripts%2FMyHealth.build.json&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=octetStream&api-version=5.0&download=true' -UseBasicParsing -OutFile '.\MyHealth.build.json'
Invoke-WebRequest 'https://dev.azure.com/secureDevOpsDelivery/82dd0a19-ef30-4974-837a-b876e341813a/_apis/git/repositories/42215aa8-8ad3-4dbc-bd08-29ffc8c37e90/items?path=%2FReleaseScripts%2FMyHealth.Release.json&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=octetStream&api-version=5.0&download=true' -UseBasicParsing -OutFile '.\MyHealth.Release.json'

#Create a Repo for the Labs
Write-Host 'Importing labs to your Azure DevOps'
az repos create --name $repomyclinic --project "DevSecOps"

#Import the repo from Demo Website
Write-Host 'Running importing Lab to student repo ......' 
az repos import create --git-source-url 'https://SecureDevOpsDelivery@dev.azure.com/SecureDevOpsDelivery/MyHealthClinicSecDevOps-Public/_git/MyHealthClinicSecDevOps-Public' --detect true --project "DevSecOps" --repository $repomyclinic

Write-Host 'Adding security extensions to your Azure DevOps'
az devops extension install --extension-id 'AzSDK-task' --publisher-id 'azsdktm' --detect true
az devops extension install --extension-id 'sonarqube' --publisher-id 'SonarSource' --detect true
az devops extension install --extension-id 'replacetokens' --publisher-id 'qetza' --detect true
az devops extension install --extension-id 'ws-bolt' --publisher-id 'whitesource' --detect true

#Creating variable group'
az pipelines variable-group create --name 'DevSecOpsVariables' --variables resourcegroupe=$rgname registry=$acrname ACR=$acrname'.azurecr.io' DatabaseName='mhcdb' ExtendedCommand='-GenerateFixScript' SQLpassword='P2ssw0rd1234' SQLserver=$sqlsvname'.database.windows.net' SQLuser='sqladmin' AppDemo=$appdemo ACRImageName=$acrname'.azurecr.io/myhealth.web:latest' Subscription=$subscription --project "DevSecOps" --authorize true

# Register the network provider
az provider register --namespace Microsoft.Network

# Create a ressource groupe
Write-Host 'Running Resource Group .....' 
if ($(az group exists --name $rgname) -eq $false)
{
    az group create --name $rgname --location $location --verbose
    Write-Host 'Ressource groupe : ' + $rgname + ' created '
}

# Create a Key Vault to store secrets
Write-Host 'Running Key Vault.....' 
if ($kvexists -eq $false)
{
    az keyvault create --location $location --name $keyvaultname --resource-group $rgname --sku standard
    az keyvault secret set --name SQLpassword --vault-name $keyvaultname --value P2ssw0rd1234
    Write-Host 'Keyvault : ' + $keyvaultname + ' created '
}

# Create ACR service
Write-Host 'Running ACR service .....' 
if ($acrexists -eq $false)
{
    az acr create --resource-group $rgname --name $acrname --sku Standard --location $location --admin-enabled true
    Write-Host 'Azure Container Registry : ' + $acrname + ' created '
}

# Create database server
Write-Host 'Running database server .....' 
if ($dbexists -eq $false)
{
    az sql server create -l $location -g $rgname -n $sqlsvname -u sqladmin -p P2ssw0rd1234
    Write-Host 'Azure SQL Server : ' + $sqlsvname + ' created '

    az sql server firewall-rule create -g $rgname -s $sqlsvname -n azsvc --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

    az sql db create -g $rgname -s $sqlsvname -n mhcdb --service-objective S0
    Write-Host 'Databae on SQL Server : mhcdb created '
}

# Create service plan for OWASP top 10
Write-Host 'Running service plan .....' 
if ($svcpexists -eq $false)
{
    az appservice plan create -g $rgname -n $appServicePlan --is-linux --number-of-workers 2 --sku P1v2
    Write-Host 'Azure App Service plan : ' + $appServicePlan + ' created '
}

# Create service WebApp for OWASP top 10
Write-Host 'Running WebApp .....' 
if ($appexists -eq $false)
{
    az webapp create --resource-group $rgname --plan $appServicePlan --name $app --deployment-container-image-name demosecops/juice-shop:v9.3.1
    Write-Host 'Azure Web App : ' + $app + ' created '
}

# Create service WebApp for containers which is our MyHealth Clinic
Write-Host 'Running WebApp .....' 
if ($appdemoexists -eq $false)
{
    az webapp create --resource-group $rgname --plan $appServicePlan --name $appdemo -i $acrname".azurecr.io/demo"
    Write-Host 'Azure Web App : ' + $appdemo + ' created '

    az webapp config connection-string set -g $rgname -n $appdemo -t SQLAzure --settings defaultConnection='Data Source=tcp:'$sqlsvname'.database.windows.net,1433;Initial Catalog=mhcdb;User Id=sqladmin;Password=P2ssw0rd1234;'

}

# Create service SonarQube  in Azure Container Instances
Write-Host 'Running SonarQube .....' 
if ($snrexists -eq $false)
{
    az container create -g $($rgname) --name $sonarqaciname --image sonarqube --ports 9000 --dns-name-label $sonarqaciname'dns' --cpu 2 --memory 3.5
    Write-Host 'Azure Web App SonarQube : ' + $sonarqaciname + ' created '
}

#Create the Azure DevOps Pipeline
Write-Host 'Create the Azure DevOps Pipeline (Please ignore errors after this step, this will be solved on the module 1) .....' 
az pipelines create --name 'MyHealthClinicSecDevOps-CICD' --description 'Pipeline for contoso project'  --repository MyHealthClinicSecDevOps-Public --branch master --yml-path azure-pipelines.yml --repository-type tfsgit

# Create service SonarQube  in Azure Container Instances
Write-Host "====================================================================================================== 
Please take note of the following ressource names, they will be used in the next labs 
====================================================================================================== 
			Azure Container Registry name : $($acrname).azurecr.io 
			SQL Server name : $($sqlsvname).database.windows.net
			Resource Groupe name : $($rgname) 

            OWASP Juice shop: 
            https://$($app).azurewebsites.net

			SonarQube Instance: 
			http://$($sonarqaciname)dns.eastus.azurecontainer.io:9000 

			Demo WebApp: 
            https://$($appdemo).azurewebsites.net

            Subscription ID 
            $($subscription)

            Azure DevOps Project 
            $($devopsservice)/DevSecOps

            Build, Release and adctional files are on :
            c:\users\student "

az account show