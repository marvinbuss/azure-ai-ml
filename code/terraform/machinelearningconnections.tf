resource "azapi_resource" "machine_learning_workspace_connection_search" {
  count = var.search_service_enabled ? 1 : 0

  type      = "Microsoft.MachineLearningServices/workspaces/connections@2023-06-01-preview"
  name      = azurerm_search_service.search_service[0].name
  parent_id = azurerm_machine_learning_workspace.machine_learning_workspace.id

  body = jsonencode({
    properties = {
      authType = "ApiKey"
      category = "CognitiveSearch"
      credentials = {
        key = azurerm_search_service.search_service[0].primary_key
      }
      metadata = {}
      target   = "https://${azurerm_search_service.search_service[0].name}.cognitiveservices.azure.com/"
    }
  })
}
