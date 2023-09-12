resource "azurerm_machine_learning_datastore_blobstorage" "machine_learning_datastore_blobstorage_default" {
  name         = "workspaceblobstore"
  workspace_id = azurerm_machine_learning_workspace.machine_learning_workspace.id

  account_key                = azurerm_storage_account.storage.primary_access_key
  description                = "Primary Blob Storage"
  is_default                 = true
  service_data_auth_identity = "WorkspaceUserAssignedIdentity"
  storage_container_id       = azurerm_storage_container.storage_container_machine_learning_workspace.id
}

resource "azurerm_machine_learning_datastore_fileshare" "machine_learning_datastore_fileshare_default" {
  name         = "workspacefilestore"
  workspace_id = azurerm_machine_learning_workspace.machine_learning_workspace.id

  account_key           = azurerm_storage_account.storage.primary_access_key
  description           = "Primary File Storage"
  service_data_identity = "WorkspaceUserAssignedIdentity"
  storage_fileshare_id  = azurerm_storage_share.storage_share_machine_learning_workspace.id
}
