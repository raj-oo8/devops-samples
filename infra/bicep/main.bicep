param staticSiteName string
var subscriptionId = subscription().subscriptionId
var uniqueSuffix = substring(subscriptionId, length(subscriptionId) - 12, 12)

module signalRModule 'azuresignalr.bicep' = {
  name: 'signalRDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    signalRName: 'signalr-${uniqueSuffix}'
    signalRLocation: 'southeastasia'
    signalRSku: 'Free_F1'
  }
}

module storageModule 'azurestorage.bicep' = {
  name: 'storageDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    storageAccountName: 'storage${uniqueSuffix}'
    storageLocationName: 'southeastasia'
    storageSkuName: 'Standard_LRS'
  }
}

module staticWebAppModule 'azurestaticwebapps.bicep' = {
  name: 'staticWebAppDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    staticSiteName: 'staticsite-${uniqueSuffix}'
    staticSiteLocation: 'southeastasia'
    staticSiteSku: 'Free'
  }
}

module functionAppModule 'azurefunctions.bicep' = {
  name: 'functionAppDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    functionAppName: 'function-${uniqueSuffix}'
    functionAppLocation: 'southeastasia'
    hostingPlanName: 'functionhosting-${uniqueSuffix}'
    hostingPlanLocation: 'southeastasia'
    storageAccountConnectionString: storageModule.outputs.storageAccountConnectionString
    signalRConnectionString: signalRModule.outputs.signalRConnectionString
    staticSiteEndpoint: staticWebAppModule.outputs.staticSiteEndpoint
  }
}
