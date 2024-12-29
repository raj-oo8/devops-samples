targetScope='subscription'

param resourceGroupName string
param resourceGroupLocation string

resource newResourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}
