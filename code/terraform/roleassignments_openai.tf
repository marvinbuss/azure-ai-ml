resource "azurerm_role_assignment" "uai_role_assignment_storage_blob_reader" {
  count = var.open_ai_enabled ? 1 : 0

  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_cognitive_account.cognitive_account.identity[0].principal_id
}
