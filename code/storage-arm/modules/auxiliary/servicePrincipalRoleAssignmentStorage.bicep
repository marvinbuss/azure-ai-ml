// This template is used to create a role assignment.
targetScope = 'resourceGroup'

// Parameters
param storageId string
@allowed([
  'Reader'
  'StorageBlobDataReader'
  'StorageBlobDataContributor'
  'StorageBlobDataOwner'
])
param role string
param servicePrincipalClientId string

// Variables
var storageName = length(split(storageId, '/')) >= 9 ? last(split(storageId, '/')) : 'incorrectSegmentLength'
var roles = {
  Reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  StorageBlobDataReader: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
  StorageBlobDataContributor: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  StorageBlobDataOwner: 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b'
}

// Resources
resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageName
  scope: resourceGroup()
}

resource synapseRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(uniqueString(subscription().subscriptionId, storage.id, roles[role]))
  scope: storage
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roles[role])
    principalId: servicePrincipalClientId
    principalType: 'ServicePrincipal'
  }
}

// Outputs