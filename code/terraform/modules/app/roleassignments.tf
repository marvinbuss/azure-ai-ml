# Function role assignments
resource "azurerm_role_assignment" "function_role_assignment_storage" {
  scope                = module.storage_account.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azapi_resource.app.identity[0].principal_id
}

resource "azurerm_role_assignment" "function_role_assignment_key_vault" {
  scope                = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azapi_resource.app.identity[0].principal_id
}

# Must be enabled when disabling local auth for Application Insights
# resource "azurerm_role_assignment" "function_role_assignment_application_insights" {
#   scope                = azurerm_application_insights.application_insights.id
#   role_definition_name = "Monitoring Metrics Publisher"
#   principal_id         = azapi_resource.app.identity[0].principal_id
# }

# Service Principal Role Assignments
resource "azurerm_role_assignment" "sp_role_assignment_function" {
  count = var.sp_object_id != "" ? 1 : 0

  scope                = azapi_resource.app.id
  role_definition_name = "Contributor"
  principal_id         = var.sp_object_id
}

# Operations role assignments
resource "azurerm_role_assignment" "operations_role_assignment_rg" {
  count = var.users_object_id != "" ? 1 : 0

  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  role_definition_name = "Reader"
  principal_id         = var.users_object_id
}

resource "azurerm_role_assignment" "operations_role_assignment_function_contributor" {
  count = var.users_object_id != "" ? 1 : 0

  scope                = azapi_resource.app.id
  role_definition_name = "Website Contributor"
  principal_id         = var.users_object_id
}

resource "azurerm_role_assignment" "operations_role_assignment_function_configuration_owner" {
  count = var.users_object_id != "" ? 1 : 0

  scope                = azapi_resource.app.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = var.users_object_id
}
