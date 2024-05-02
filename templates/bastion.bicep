param bastionname string
param location string
param bassubnetid string
param bastpubip string

resource bastion 'Microsoft.Network/bastionHosts@2023-09-01'= {
  name: bastionname
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    scaleUnits: 2
    enableIpConnect: true
    enableShareableLink: true
    ipConfigurations: [
      {
        name: 'ipConf'
        properties:{
          subnet: {
            id: bassubnetid
          }
          publicIPAddress:{
            id: bastpubip
          }
        }
      }     
    ]
  }
}
