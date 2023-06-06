resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: 'vnet-001'
  location: resourceGroup().location
  tags: {
    Owner: 'Team A'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '100.0.0.0/15'
      ]
    }
    enableVmProtection: false
    enableDdosProtection: false
    subnets: [
      {
        name: 'subnet002'
        properties: {
          addressPrefix: '100.0.1.0/24'
        }
      }
    ]
  }
}
