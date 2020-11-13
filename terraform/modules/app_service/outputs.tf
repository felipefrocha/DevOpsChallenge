output "outbound_ip_addresses" {
  value = azurerm_app_service.main.*.outbound_ip_addresses
}