resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = "${local.prefix}-uai001"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_ml.name
  tags                = var.tags
}
