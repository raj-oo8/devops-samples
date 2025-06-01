var uniqueSuffix = replace(guid(subscription().subscriptionId), '-', '')
var location = 'eastasia'

targetScope='subscription'

resource newResourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: 'group-${uniqueSuffix}'
  location: location
}

module signalRModule 'azuresignalr.bicep' = {
  name: 'signalRDeployment'
  scope: newResourceGroup
  params: {
    signalRName: 'signalr-${uniqueSuffix}'
    signalRLocation: location
    signalRSku: 'Free_F1'
  }
}

module storageModule 'azurestorage.bicep' = {
  name: 'storageDeployment'
  scope: newResourceGroup
  params: {
    storageAccountName: 'storage${uniqueSuffix}'
    storageLocationName: location
    storageSkuName: 'Standard_LRS'
  }
}

module staticWebAppModule 'azurestaticwebapps.bicep' = {
  name: 'staticWebAppDeployment'
  scope: newResourceGroup
  params: {
    staticSiteName: 'singlepageapp-${uniqueSuffix}'
    staticSiteLocation: location
    staticSiteSku: 'Free'
  }
}

module functionAppModule 'azurefunctions.bicep' = {
  name: 'functionAppDeployment'
  scope: newResourceGroup
  params: {
    functionAppName: 'function-${uniqueSuffix}'
    functionAppLocation: location
    hostingPlanName: 'functionhosting-${uniqueSuffix}'
    hostingPlanLocation: location
    staticSiteEndpoint: staticWebAppModule.outputs.staticSiteEndpoint
    storageAccountName: storageModule.outputs.storageAccountName
    signalRName: signalRModule.outputs.signalRName
  }
}

output newResourceGroupName string = newResourceGroup.name
output staticSiteName string = staticWebAppModule.outputs.staticSiteName
output functionAppName string = functionAppModule.outputs.functionAppName
output functionAppEndpoint string = functionAppModule.outputs.functionAppEndpoint
