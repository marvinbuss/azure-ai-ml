resource "azurerm_role_assignment" "readers_role_assignment_resource_group_logging_reader" {
  scope                = azurerm_resource_group.resource_group_logging.id
  role_definition_name = "Reader"
  principal_id         = var.readers_object_id
}

resource "azurerm_role_assignment" "readers_role_assignment_resource_group_ml_reader" {
  scope                = azurerm_resource_group.resource_group_ml.id
  role_definition_name = "Reader"
  principal_id         = var.readers_object_id
}

resource "azurerm_role_assignment" "readers_role_assignment_resource_group_cs_reader" {
  scope                = azurerm_resource_group.resource_group_cs.id
  role_definition_name = "Reader"
  principal_id         = var.readers_object_id
}

resource "azurerm_role_assignment" "readers_role_assignment_storage" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = var.readers_object_id
}

resource "azurerm_role_assignment" "readers_role_assignment_cognitive_account_cognitive_services_data_reader" {
  count                = var.open_ai_enabled ? 1 : 0
  scope                = azurerm_cognitive_account.cognitive_account[0].id
  role_definition_name = "Cognitive Services Data Reader (Preview)"
  principal_id         = var.readers_object_id
}

resource "azurerm_role_assignment" "readers_role_assignment_cognitive_account_cognitive_services_usages_reader" {
  count                = var.open_ai_enabled ? 1 : 0
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Cognitive Services Usages Reader"
  principal_id         = var.readers_object_id
}

resource "azurerm_role_assignment" "readers_role_assignment_cognitive_accounts_cognitive_services_data_reader" {
  for_each = var.cognitive_services

  scope                = azurerm_cognitive_account.cognitive_accounts[each.key].id
  role_definition_name = "Cognitive Services Data Reader (Preview)"
  principal_id         = var.readers_object_id
}
