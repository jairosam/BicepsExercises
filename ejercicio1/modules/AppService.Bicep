param location string = resourceGroup().location
param appServiceAppName string = 'appserviceappgp${uniqueString(resourceGroup().id)}'

@allowed([
  'nonprod'
  'prod'
])
param sku string

var skuAppServicePlan = (sku == 'prod') ? 'P2V3' : 'F1'
var appServicePlanName = 'appserviceplangp${uniqueString(resourceGroup().id)}'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuAppServicePlan
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-09-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName

