resource "azurerm_resource_group" "resource_group_logging" {
  name     = "${local.prefix}-logging"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "resource_group_ml" {
  name     = "${local.prefix}-ml"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "resource_group_cs" {
  name     = "${local.prefix}-cs"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "resource_group_asp" {
  name     = "${local.prefix}-asp"
  location = var.location
  tags     = var.tags
}
