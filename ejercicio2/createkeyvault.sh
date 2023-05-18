#!/bin/bash

keyVaultName="KeyVaultTestGpBicep"
read -p "Enter the login name : " login 
read -p "Enter the password: " password

az keyvault create --name $keyVaultName --location eastus --enabled-for-template-deployment true --resource-group testbicep

az keyvault secret set --vault-name $keyVaultName --name "sqlServerAdministratorLogin" --value $login --output none
az keyvault secret set --vault-name $keyVaultName --name "sqlServerAdministratorPassword" --value $password --output none
