using './main.bicep'

param location = 'northeurope'
param environment = 'dev'
param prefix = 'adoagent'
param tags = {}
param subnetId = '/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-logic-network-rg/providers/Microsoft.Network/virtualNetworks/mycrp-prd-logic-vnet001/subnets/PeSubnet'
param virtualMachineSku = 'Standard_D2ds_v4'
param administratorUsername = 'VmMainUser'
param administratorPassword = '<provided-in-pipeline>'
