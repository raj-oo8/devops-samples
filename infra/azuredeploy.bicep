param staticSites_name string = 'azure-static-web-app'
param staticSites_location string = 'East Asia'
param staticSites_sku string = 'Free'

resource staticSite 'Microsoft.Web/staticSites@2023-01-01' = {
  name: staticSites_name
  location: staticSites_location
  sku: {
    name: staticSites_sku
  }
  properties: {
  }
}
