# **IPv6 over an IPv4 IPSec VPN with Network Virtual Appliances**

Although Azure VNET supports IPv4/IPv6 dual stack networking, the Site-to-site VPN VNET Gateway today does not. A VPN Gateway can be deployed in a dual stack VNET, but it will only allow IPv4 over VPN tunnels. The public (or private in the case of VPN over ExpressRoute) tunnel endpoint addesses can also only be IPv4.
IPv6 transport over VPN is in development at the time of writing this in May 2024, but an availability date has not been announced.

Router- and Firewall Network Virtual Appliances from various vendors support IPv6 VPN.

This lab demonstrates an IPv6 VPN solution between two Cisco Catalyst 8000v routers.

![images](images/ipv6-over-vpn-nva.png)

# Deployment

Log in to Azure Cloud Shell at https://shell.azure.com/ and select Bash.

Create an empty Resource Group:

            az group create --name [rg-name] --location [azure-region]

# Configuration

# Testing



-	Use Serial Console to log on the each of the routers:
o	Username: AzureAdmin
o	Password: ipV6demo-2024


