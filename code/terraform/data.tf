data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = local.subnet.name
  virtual_network_name = local.subnet.virtual_network_name
  resource_group_name  = local.subnet.resource_group_name
}
