param signalRName string
param signalRLocation string
param signalRSku string

resource signalR 'Microsoft.SignalRService/signalR@2024-10-01-preview' = {
  name: signalRName
  location: signalRLocation
  sku: {
    name: signalRSku
  }
  properties: {
    features: [
      {
        flag: 'ServiceMode'
        value: 'Serverless'
      }
    ]
  }
}

output signalRConnectionString string = listKeys(signalR.id, signalR.apiVersion).primaryConnectionString


