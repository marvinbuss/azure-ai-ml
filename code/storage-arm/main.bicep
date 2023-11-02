targetScope = 'subscription'

// General parameters
@description('Specifies the location for all resources.')
param location string
@allowed([
  'dev'
  'tst'
  'prd'
])
@description('Specifies the environment of the deployment.')
param environment string = 'dev'
@minLength(2)
@maxLength(10)
@description('Specifies the prefix for all resources created in this deployment.')
param prefix string
@description('Specifies the tags that you want to apply to all resources.')
param tags object = {}

// Storage parameters
@description('Specifies an array with storage container names used for the Terraform deployment.')
param storageContainerNames array

// Identity parameters
@description('Specifies the client ID of a service principal used for the Terraform deployment.')
param servicePrincipalClientId string

// Network parameters
@description('Specifies the resource ID of the subnet to which all services will connect.')
param subnetId string
@description('Specifies the resource ID of the private DNS zone for Blob Storage.')
param privateDnsZoneIdBlob string = ''

// Variables
var name = toLower('${prefix}-${environment}')
var resourceGroup001Name = 'rg-terraform-${name}'
var storage001Name = '${name}-storage001'

// Resources
resource resourceGroup001 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroup001Name
  location: location
  tags: tags
  properties: {}
}

module storage001 'modules/services/storage.bicep' = {
  name: 'storage001'
  scope: resourceGroup001
  params: {
    location: location
    tags: tags
    subnetId: subnetId
    storageName: storage001Name
    storageContainerNames: storageContainerNames
    storageSkuName: 'Standard_ZRS'
    privateDnsZoneIdBlob: privateDnsZoneIdBlob
  }
}

module storage001RoleAssignmentServicePrincipalReader 'modules/auxiliary/servicePrincipalRoleAssignmentStorage.bicep' = {
  name: 'storage001RoleAssignmentServicePrincipalReader'
  scope: resourceGroup001
  params: {
    role: 'Reader'
    servicePrincipalClientId: servicePrincipalClientId
    storageId: storage001.outputs.storageId
  }
}

module storage001RoleAssignmentServicePrincipalStorageBlobDataOwner 'modules/auxiliary/servicePrincipalRoleAssignmentStorage.bicep' = {
  name: 'storage001RoleAssignmentServicePrincipalStorageBlobDataOwner'
  scope: resourceGroup001
  params: {
    role: 'Reader'
    servicePrincipalClientId: servicePrincipalClientId
    storageId: storage001.outputs.storageId
  }
}
