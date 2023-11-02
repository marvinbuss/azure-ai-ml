using './main.bicep'

param location = 'northeurope'
param environment = 'dev'
param prefix = 'tfstrg0783'
param tags = {}
param storageContainerNames = [
  'terraform'
]
param servicePrincipalClientId = '4b9deed4-7d41-48e6-a429-bef3232b7477'
param subnetId = '/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-logic-network-rg/providers/Microsoft.Network/virtualNetworks/mycrp-prd-logic-vnet001/subnets/PeSubnet'
#disable-next-line no-hardcoded-env-urls
param privateDnsZoneIdBlob = '/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net'
