output "vpnGwPipAddress" {
  value = "${azurerm_public_ip.vpnGatewayPublicIp.ip_address}"
}