param storageAccountName string
param storageLocationName string
param storageSkuName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: storageLocationName
  kind: 'StorageV2'
  sku: {
    name: storageSkuName
  }
}

output storageAccountConnectionString string = listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value
