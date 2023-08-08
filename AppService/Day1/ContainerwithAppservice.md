# Module 0 : Parameter
$acrname  : <Ganti dengan nama ACR>
$acrlogin : <Ganti dengan nama ACR login>
$acrpass  : <Ganti dengan nama ACR password>
# Module 1 Login to Registry
az login

az acr login --name $acrname

# Module 2 Pull public image


# Module 3 run container secara local
https://learn.microsoft.com/en-us/azure/container-registry/container-registry-get-started-docker-cli?tabs=azure-cli
