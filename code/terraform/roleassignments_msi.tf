resource "azurerm_role_assignment" "uai_role_assignment_resource_group_cs_reader" {
  scope                = azurerm_resource_group.resource_group_cs.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

resource "azurerm_role_assignment" "uai_role_assignment_resource_group_logging_reader" {
  scope                = azurerm_resource_group.resource_group_logging.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

resource "azurerm_role_assignment" "uai_role_assignment_resource_group_ml_reader" {
  scope                = azurerm_resource_group.resource_group_ml.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

resource "azurerm_role_assignment" "uai_role_assignment_container_registry_contributor" {
  scope                = azurerm_container_registry.container_registry.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

resource "azurerm_role_assignment" "uai_role_assignment_storage_contributor" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

resource "azurerm_role_assignment" "uai_role_assignment_storage_blob_contributor" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

resource "azurerm_role_assignment" "uai_role_assignment_storage_table_contributor" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

resource "azurerm_role_assignment" "uai_role_assignment_storage_file_data_priviliged_contributor" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage File Data Privileged Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

resource "azurerm_role_assignment" "uai_role_assignment_key_vault_contributor" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

resource "azurerm_role_assignment" "uai_role_assignment_key_vault_administrator" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

resource "azurerm_role_assignment" "uai_role_assignment_application_insights_contributor" {
  scope                = azurerm_application_insights.application_insights.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

resource "azurerm_role_assignment" "uai_role_assignment_machine_learning_workspace_contributor" {
  scope                = azurerm_machine_learning_workspace.machine_learning_workspace.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

resource "azurerm_role_assignment" "uai_role_assignment_search_service_contributor" {
  count                = var.search_service_enabled ? 1 : 0
  scope                = azurerm_search_service.search_service[0].id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

resource "azurerm_role_assignment" "uai_role_assignment_cognitive_account_contributor" {
  count                = var.open_ai_enabled ? 1 : 0
  scope                = azurerm_cognitive_account.cognitive_account[0].id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}
