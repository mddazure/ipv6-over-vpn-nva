param location string = 'swedencentral'
param Spoke1v4AddressRange string = '10.1.0.0/16'
param Spoke1v6AddressRange string = 'ac1:cab:deca::/48'
param Spoke1subnet1v4AddressRange string = '10.1.0.0/24'
param Spoke1BastionSubnetAddressRange string = '10.1.1.0/24'

param Spoke1subnet1v6AddressRange string = 'ac1:cab:deca:deed::/64'
param Spoke2v4AddressRange string = '10.2.0.0/16'
param Spoke2v6AddressRange string = 'ac2:cab:deca::/48'
param Spoke2subnet1v4AddressRange string = '10.2.0.0/24'
param Spoke2subnet1v6AddressRange string = 'ac2:cab:deca:deed::/64'
param Spoke2BastionSubnetAddressRange string = '10.2.1.0/24'

var vm1name = 'vm1'
var vm1Ipv4Private = '${substring(Spoke1subnet1v4AddressRange,0,7)}${'4'}' //'10.1.0.4'
var vm1Ipv6Private = '${substring(Spoke1subnet1v6AddressRange,0,19)}${'4'}' //'ac1:cab:deca:deed::4'
var vm2name = 'vm2'
var vm2Ipv4Private = '${substring(Spoke2subnet1v4AddressRange,0,7)}${'4'}' //'10.2.0.4'
var vm2Ipv6Private = '${substring(Spoke2subnet1v6AddressRange,0,19)}${'4'}' //'ac2:cab:deca:deed::4'
var csr1name = 'c8k1'
var csr1Ipv4Private = '${substring(Spoke1subnet1v4AddressRange,0,7)}${'5'}' //'10.1.0.5'
var csr1Ipv6Private = '${substring(Spoke1subnet1v6AddressRange,0,19)}${'5'}' //'ac1:cab:deca:deed::5'
var csr2name = 'c8k2'
var csr2Ipv4Private = '${substring(Spoke2subnet1v4AddressRange,0,7)}${'5'}' //'10.2.0.5'
var csr2Ipv6Private = '${substring(Spoke2subnet1v6AddressRange,0,19)}${'5'}' //'ac2:cab:deca:deed::5'
var bastion1name = 'bastion1'
var bastion2name = 'bastion2'



param adminUsername string = 'AzureAdmin'
@secure()
param adminPassword string = 'ipV6demo-2024'

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
resource csr1pubIpV4 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'csr1pubIpV4'
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
resource csr2pubIpV4 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'csr2pubIpV4'
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
resource bastion1pubIpV4 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'bastion1pubIpV4'
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
resource bastion2pubIpV4 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'bastion2pubIpV4'
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
  }
}
resource dsSpoke1subnet1 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  parent: dsSpoke1
  name: 'dsSpoke1subnet1'
  properties:{
    addressPrefixes:[
      Spoke1subnet1v4AddressRange
      Spoke1subnet1v6AddressRange
    ]
    networkSecurityGroup: {
      id: nsg.id
    }
    routeTable: {
      id: udr1.id
    }
  }
}
resource dsSpoke1BastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  parent: dsSpoke1
  name: 'AzureBastionSubnet'
  dependsOn:[
    dsSpoke1subnet1
  ]
  properties:{
    addressPrefixes:[
      Spoke1BastionSubnetAddressRange     
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
  }
}
resource dsSpoke2subnet1 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  parent: dsSpoke2
  name: 'dsSpoke2subnet1'
  properties:{
    addressPrefixes:[
      Spoke2subnet1v4AddressRange
      Spoke2subnet1v6AddressRange
    ]
    networkSecurityGroup: {
      id: nsg.id
    }
    routeTable: {
      id: udr2.id
    }
  }
}
resource dsSpoke2BastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  parent: dsSpoke2
  name: 'AzureBastionSubnet'
  dependsOn:[
    dsSpoke2subnet1
  ]
  properties:{
    addressPrefixes:[
      Spoke2BastionSubnetAddressRange     
    ]
  }
}
//UDRs
resource udr1 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'udr1'
  location: location
  properties: {
    routes: [
      {
        name: 'spoke2v4'
        properties: {
          addressPrefix: Spoke2v4AddressRange
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: csr1Ipv4Private
         }
      }
      {
        name: 'spoke2v6'
        properties: {
          addressPrefix: Spoke2v6AddressRange
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: csr1Ipv4Private
        }
      }
    ]
  }
}
resource udr2 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'udr2'
  location: location
  properties: {
    routes: [
      {
        name: 'spoke1v4'
        properties: {
          addressPrefix: Spoke1v4AddressRange
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: csr2Ipv4Private
         }
      }
      {
        name: 'spoke1v6'
        properties: {
          addressPrefix: Spoke1v6AddressRange
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: csr2Ipv4Private
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
module csr1 'csr.bicep'= {
name: 'csr1'
params: {
  adminUser: adminUsername
  adminPw: adminPassword
  vmName: csr1name
  pubIpv4Id: csr1pubIpV4.id
  subnetId: dsSpoke1subnet1.id
  location: location
  privateIpV4: csr1Ipv4Private
  privateIpV6: csr1Ipv6Private
  }
}
module csr2 'csr.bicep'= {
  name: 'csr2'
  params: {
    adminUser: adminUsername
    adminPw: adminPassword
    vmName: csr2name
    pubIpv4Id: csr2pubIpV4.id
    subnetId: dsSpoke2subnet1.id
    location: location
    privateIpV4: csr2Ipv4Private
    privateIpV6: csr2Ipv6Private
    }
  }
module vm1 'vm.bicep' = {
  name: 'vm1'
  params: {
    adminUser: adminUsername
    adminPw: adminPassword
    location: location
    privateIPv4: vm1Ipv4Private
    privateIPv6: vm1Ipv6Private
    vmName: vm1name
    subnetId: dsSpoke1subnet1.id
  }
}
module vm2 'vm.bicep' = {
  name: 'vm2'
  params: {
    adminUser: adminUsername
    adminPw: adminPassword
    location: location
    privateIPv4: vm2Ipv4Private
    privateIPv6: vm2Ipv6Private
    vmName: vm2name
    subnetId: dsSpoke2subnet1.id
  }
}
module bastion1 'bastion.bicep' ={
  name: 'bastion1'
  params:{
    location: location
    bastionname: bastion1name
    bassubnetid: dsSpoke1BastionSubnet.id
    bastpubip: bastion1pubIpV4.id
  }
}
module bastion2 'bastion.bicep' ={
  name: 'bastion2'
  params:{
    location: location
    bastionname: bastion2name
    bassubnetid: dsSpoke2BastionSubnet.id
    bastpubip: bastion2pubIpV4.id
  }
}
