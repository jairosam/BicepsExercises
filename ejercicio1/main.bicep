param location string = resourceGroup().location
param appServiceAppName string = 'appserviceappgp${uniqueString(resourceGroup().id)}'
@allowed([
  'nonprod'
  'prod'
])
param sku string

var skuStorageAccount = (sku == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'testlaunchstoragegp'
  location: location
  tags: {
    type: 'test'
  }
  sku: {
    name: skuStorageAccount
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

module appService 'modules/AppService.Bicep' = {
  name: 'appServiceApp'
  params: {
    location: location
    appServiceAppName: appServiceAppName
    sku: sku
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
