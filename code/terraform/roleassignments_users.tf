resource "azurerm_role_assignment" "users_role_assignment_resource_group_logging_reader" {
  scope                = azurerm_resource_group.resource_group_logging.id
  role_definition_name = "Reader"
  principal_id         = var.users_object_id
}

resource "azurerm_role_assignment" "users_role_assignment_resource_group_ml_reader" {
  scope                = azurerm_resource_group.resource_group_ml.id
  role_definition_name = "Reader"
  principal_id         = var.users_object_id
}

resource "azurerm_role_assignment" "users_role_assignment_resource_group_cs_reader" {
  scope                = azurerm_resource_group.resource_group_cs.id
  role_definition_name = "Reader"
  principal_id         = var.users_object_id
}

resource "azurerm_role_assignment" "users_role_assignment_storage" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.users_object_id
}

resource "azurerm_role_assignment" "users_role_assignment_key_vault_administrator" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.users_object_id
}

resource "azurerm_role_assignment" "users_role_assignment_user_assigned_identity_managed_identity_operator" {
  scope                = azurerm_user_assigned_identity.user_assigned_identity.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.users_object_id
}

resource "azurerm_role_assignment" "users_role_assignment_machine_learning_workspace_azure_ai_developer" {
  scope                = azurerm_machine_learning_workspace.machine_learning_workspace.id
  role_definition_name = "Azure AI Developer"
  principal_id         = var.users_object_id
}

resource "azurerm_role_assignment" "users_role_assignment_search_service_search_index_data_contributor" {
  count                = var.search_service_enabled ? 1 : 0
  scope                = azurerm_search_service.search_service[0].id
  role_definition_name = "Search Index Data Contributor"
  principal_id         = var.users_object_id
}

resource "azurerm_role_assignment" "users_role_assignment_cognitive_account_cognitive_services_openai_contributor" {
  count                = var.open_ai_enabled ? 1 : 0
  scope                = azurerm_cognitive_account.cognitive_account[0].id
  role_definition_name = "Cognitive Services OpenAI Contributor"
  principal_id         = var.users_object_id
}

resource "azurerm_role_assignment" "users_role_assignment_cognitive_account_cognitive_services_user" {
  count                = var.open_ai_enabled ? 1 : 0
  scope                = azurerm_cognitive_account.cognitive_account[0].id
  role_definition_name = "Cognitive Services User"
  principal_id         = var.users_object_id
}

resource "azurerm_role_assignment" "users_role_assignment_cognitive_account_cognitive_services_usages_reader" {
  count                = var.open_ai_enabled ? 1 : 0
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Cognitive Services Usages Reader"
  principal_id         = var.users_object_id
}

resource "azurerm_role_assignment" "users_role_assignment_cognitive_accounts_cognitive_services_user" {
  for_each = var.cognitive_services

  scope                = azurerm_cognitive_account.cognitive_accounts[each.key].id
  role_definition_name = "Cognitive Services User"
  principal_id         = var.users_object_id
}
