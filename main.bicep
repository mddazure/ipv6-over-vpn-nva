param location string = 'westeurope'
param Spoke1v4AddressRange string = '10.1.0.0/16'
param Spoke1v6AddressRange string = 'ac1:cab:deca::/48'
param Spoke1subnet1v4AddressRange string = '10.1.0.0/24'
param Spoke1subnet1v6AddressRange string = 'ac1:cab:deca:deed::/64'
param Spoke2v4AddressRange string = '10.2.0.0/16'
param Spoke2v6AddressRange string = 'ac2:cab:deca::/48'
param Spoke2subnet1v4AddressRange string = '10.2.0.0/24'
param Spoke2subnet1v6AddressRange string = 'ac2:cab:deca:deed::/64'

param adminUsername string = 'AzureAdmin'
@secure()
param adminPassword string = 'ipV6demo-2021'

//public IP prefixes
resource prefixIpV4 'Microsoft.Network/publicIPPrefixes@2020-11-01' = {
  name: 'prefixIpV4'
  location: location
  sku:{
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    prefixLength: 28
    publicIPAddressVersion: 'IPv4'
  }
}
resource prefixIpV6 'Microsoft.Network/publicIPPrefixes@2020-11-01' = {
  name: 'prefixIpV6'
  location: location
  sku:{
    name:'Standard'
    tier: 'Regional'
  }
  properties: {
    prefixLength: 125
    publicIPAddressVersion: 'IPv6'
    
  }
}

resource pubIpV41 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: 'instancePubIpV4-1'
  location: location
  sku:{
    name: 'Standard'
  }
  properties:{
    publicIPAllocationMethod: 'Static' 
    publicIPAddressVersion: 'IPv4'
    publicIPPrefix: {
      id: prefixIpV4.id
    }
  }
}
resource pubIpV42 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: 'instancePubIpV4-2'
  location: location
  sku:{
    name: 'Standard'
  }
  properties:{
    publicIPAllocationMethod: 'Static' 
    publicIPAddressVersion: 'IPv4'
    publicIPPrefix: {
      id: prefixIpV4.id
    }
  }
}

resource pubIpV61 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: 'instancePubIpv6-1'
  location: location
  sku:{
    name: 'Standard'
  }
  properties:{
    publicIPAllocationMethod: 'Static' 
    publicIPAddressVersion: 'IPv6'
    publicIPPrefix: {
      id: prefixIpV6.id
    }
  }
}
resource pubIpV62 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: 'instancePubIpv6-2'
  location: location
  sku:{
    name: 'Standard'
  }
  properties:{
    publicIPAllocationMethod: 'Static' 
    publicIPAddressVersion: 'IPv6'
    publicIPPrefix: {
      id: prefixIpV6.id
    }
  }
}
resource bastionPubIpV4 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: 'bastionPubIpV4'
  location: location
  sku:{
    name: 'Standard'
  }
  properties:{
    publicIPAllocationMethod: 'Static' 
    publicIPAddressVersion: 'IPv4'
    publicIPPrefix: {
      id: prefixIpV4.id
    }
  }

}
// VNETs
resource dsSpoke1 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: 'dsSpoke1'
  location: location
  properties:{
    addressSpace:{
      addressPrefixes:[
        Spoke1v4AddressRange
        Spoke1v6AddressRange
      ]
    }
    subnets:[
      {
      name: 'subnet1'
      properties:{
        addressPrefixes:[
          Spoke1subnet1v4AddressRange
          Spoke1subnet1v6AddressRange
        ]
        networkSecurityGroup: {
          id: nsg.id
        }
      }
    }     
    ]
  }
}
resource dsSpoke2 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: 'dsSpoke2'
  location: location
  properties:{
    addressSpace:{
      addressPrefixes:[
        Spoke2v4AddressRange
        Spoke2v6AddressRange
      ]
    }
    subnets:[
      {
      name: 'subnet1'
      properties:{
        addressPrefixes:[
          Spoke2subnet1v4AddressRange
          Spoke2subnet1v6AddressRange
        ]
        networkSecurityGroup: {
          id: nsg.id
        }
      }
    }     
    ]
  }
}

//NSG
resource nsg 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: 'nsg'
  location: location
  properties:{
    securityRules: [
      {
        name: 'allow80in'
        properties:{
          priority: 150
          direction: 'Inbound'
          protocol: 'Tcp'
          access: 'Allow'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '80'
          }
      }
      {
        name: 'allowAllout'
        properties:{
          priority: 250
          direction: 'Outbound'
          protocol: 'Tcp'
          access: 'Allow'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          }
      }
      {
        name: 'allow22in'
        properties:{
          priority: 160
          direction: 'Inbound'
          protocol: 'Tcp'
          access: 'Allow'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
          }
      }
    ]
  }
}
