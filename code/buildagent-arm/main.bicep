targetScope = 'subscription'

// General parameters
@description('Specifies the location of your Data Landing Zone or Data Management Zone.')
param location string
@allowed([
  'dev'
  'tst'
  'prd'
])
@description('Specifies the environment of your Data Landing Zone or Data Management Zone.')
param environment string = 'dev'
@minLength(2)
@maxLength(10)
@description('Specifies the prefix of your Data Landing Zone or Data Management Zone.')
param prefix string
@description('Specifies the tags that you want to apply to all resources.')
param tags object = {}

// Virtual Machine parameters
@description('Specifies the SKU of the virtual machine that gets created.')
param virtualMachineSku string = 'Standard_D2ds_v4'
@description('Specifies the administrator username of the virtual machine.')
param administratorUsername string = 'VmMainUser'
@description('Specifies the administrator password of the virtual machine.')
@secure()
param administratorPassword string

// Network parameters
@description('Specifies the resource ID of the subnet to which all services will connect.')
param subnetId string

// Variables
var name = toLower('${prefix}-${environment}')
var resourceGroup001Name = 'rg-ado-${name}'
var selfHostedAgentDevOps001Name = '${name}-agent001'

// Resources
resource resourceGroup001 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroup001Name
  location: location
  tags: tags
  properties: {}
}

module selfHostedAgentDevOps001 'modules/services/selfHostedAgentAzureDevOps.bicep' = {
  name: 'selfHostedAgentDevOps001'
  scope: resourceGroup001
  params: {
    location: location
    tags: tags
    administratorUsername: administratorUsername
    administratorPassword: administratorPassword
    subnetId: subnetId
    vmssName: selfHostedAgentDevOps001Name
    vmssSkuName: virtualMachineSku
    vmssSkuTier: 'Standard'
    vmssSkuCapacity: 1
  }
}

// Outputs
