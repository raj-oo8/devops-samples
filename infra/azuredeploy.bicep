param staticSites_name string
param staticSites_location string
param staticSites_sku string

resource staticSite 'Microsoft.Web/staticSites@2023-01-01' = {
  name: staticSites_name
  location: staticSites_location
  sku: {
    name: staticSites_sku
  }
  properties: {
  }
}
