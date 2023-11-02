// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

// This template is used to create a Self-hosted Integration Runtime.
targetScope = 'resourceGroup'

// Parameters
param location string
param tags object
param subnetId string
param vmssName string
param vmssSkuName string = 'Standard_D2ds_v4'
param vmssSkuTier string = 'Standard'
param vmssSkuCapacity int = 1
param administratorUsername string = 'VmssMainUser'
@secure()
param administratorPassword string

// Variables
var loadBalancerName = '${vmssName}-lb'

// Resources
resource loadbalancer 'Microsoft.Network/loadBalancers@2023-05-01' = {
  name: loadBalancerName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    backendAddressPools: [
      {
        name: '${vmssName}-backendpool'
      }
    ]
    frontendIPConfigurations: [
      {
        name: '${vmssName}-ipfrontend'
        properties: {
          subnet: {
            id: subnetId
          }
        }
      }
    ]
    inboundNatPools: [
      {
        name: '${vmssName}-natpool'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', '${vmssName}-lb', '${vmssName}-ipfrontend')
          }
          protocol: 'Tcp'
          frontendPortRangeStart: 50000
          frontendPortRangeEnd: 50099
          backendPort: 22
          idleTimeoutInMinutes: 4
        }
      }
    ]
    probes: [
      {
        name: '${vmssName}-probe'
        properties: {
          intervalInSeconds: 5
          numberOfProbes: 2
          port: 22
          protocol: 'Tcp'
        }
      }
    ]
  }
}

resource scalesetagent 'Microsoft.Compute/virtualMachineScaleSets@2023-07-01' = {
  name: vmssName
  location: location
  tags: tags
  sku: {
    name: vmssSkuName
    tier: vmssSkuTier
    capacity: vmssSkuCapacity
  }
  zones: [
    '1'
    '2'
    '3'
  ]
  properties: {
    additionalCapabilities: {}
    automaticRepairsPolicy: {}
    overprovision: false
    platformFaultDomainCount: 1
    scaleInPolicy: {
      rules: [
        'Default'
      ]
    }
    singlePlacementGroup: false
    upgradePolicy: {
      mode: 'Manual'
    }
    virtualMachineProfile: {
      diagnosticsProfile: {
        bootDiagnostics: {
          enabled: true
        }
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: '${vmssName}-nic'
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: '${vmssName}-ipconfig'
                  properties: {
                    primary: true
                    privateIPAddressVersion: 'IPv4'
                    subnet: {
                      id: subnetId
                    }
                    loadBalancerBackendAddressPools: [
                      {
                        id: loadbalancer.properties.backendAddressPools[0].id
                      }
                    ]
                    loadBalancerInboundNatPools: [
                      {
                        id: loadbalancer.properties.inboundNatPools[0].id
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
      osProfile: {
        adminUsername: administratorUsername
        adminPassword: administratorPassword
        computerNamePrefix: take(vmssName, 9)
        customData: ''
        linuxConfiguration: {
          enableVMAgentPlatformUpdates: true
          provisionVMAgent: true
          patchSettings: {
            assessmentMode: 'ImageDefault'
            patchMode: 'ImageDefault'
          }
        }
      }
      priority: 'Regular'
      storageProfile: {
        imageReference: {
          publisher: 'canonical'
          offer: '0001-com-ubuntu-server-focal'
          sku: '20_04-lts-gen2'
          version: 'latest'
        }
        osDisk: {
          createOption: 'FromImage'
          caching: 'ReadOnly'
          diffDiskSettings: {
            option: 'Local'
            placement: 'CacheDisk'
          }
          osType: 'Linux'
        }
      }
      securityProfile: {
        encryptionAtHost: true
        securityType: 'TrustedLaunch'
        uefiSettings: {
          secureBootEnabled: true
          vTpmEnabled: true
        }
      }
    }
    zoneBalance: false
  }
}

// Outputs
