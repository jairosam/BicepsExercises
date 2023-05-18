@description('The name of the environment. This must be dev, test, or prod')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string = 'dev'

@description('The unique name of the solution. This is used to ensure that resource names are unique')
@minLength(5)
@maxLength(30)
param solutionName string = 'appserivectestgp${uniqueString(resourceGroup().id)}'

@description('The number of App Service Plan instances')
@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int = 1

@description('The name and tier of the App Service plan SKU')
param appServicePlanSku object

@description('The azure region into wich the resources should be deployed')
param location string = 'eastus'

@secure()
@description('The administrator login username for the sql server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the sql server.')
param sqlServerAdministratorPassword string

@description('The name and tier of the sql database SKU.')
param sqlDatabaseSku object

var appServicePlanName = '${environmentName}-${solutionName}-plan'
var appServiceAppName = '${environmentName}-${solutionName}-app'

var sqlServerName = '${environmentName}-${solutionName}-sql'
var sqlDatabaseName = 'Employees'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku.name
    tier: appServicePlanSku.tier
    capacity: appServicePlanInstanceCount
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

resource sqlServer 'Microsoft.Sql/servers@2022-08-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-08-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: {
    name: sqlDatabaseSku.name
    tier: sqlDatabaseSku.tier

  }
}
