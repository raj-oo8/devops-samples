var subscriptionId = subscription().subscriptionId
var uniqueSuffix = substring(subscriptionId, length(subscriptionId) - 12, 12)

targetScope='subscription'

resource newResourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: 'group-${uniqueSuffix}'
  location: 'southeastasia'
}

module signalRModule 'azuresignalr.bicep' = {
  name: 'signalRDeployment'
  scope: newResourceGroup
  params: {
    signalRName: 'signalr-${uniqueSuffix}'
    signalRLocation: 'southeastasia'
    signalRSku: 'Free_F1'
  }
}

module storageModule 'azurestorage.bicep' = {
  name: 'storageDeployment'
  scope: newResourceGroup
  params: {
    storageAccountName: 'storage${uniqueSuffix}'
    storageLocationName: 'southeastasia'
    storageSkuName: 'Standard_LRS'
  }
}

module staticWebAppModule 'azurestaticwebapps.bicep' = {
  name: 'staticWebAppDeployment'
  scope: newResourceGroup
  params: {
    staticSiteName: staticSiteName
    staticSiteLocation: 'southeastasia'
    staticSiteSku: 'Free'
  }
}

module functionAppModule 'azurefunctions.bicep' = {
  name: 'functionAppDeployment'
  scope: newResourceGroup
  params: {
    functionAppName: 'function-${uniqueSuffix}'
    functionAppLocation: 'southeastasia'
    hostingPlanName: 'functionhosting-${uniqueSuffix}'
    hostingPlanLocation: 'southeastasia'
    staticSiteEndpoint: staticWebAppModule.outputs.staticSiteEndpoint
    storageAccountName: storageModule.outputs.storageAccountName
    signalRName: signalRModule.outputs.signalRName
  }
}
