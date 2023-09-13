locals {
  prefix = "${lower(var.prefix)}-${var.environment}"

  subnet = {
    resource_group_name  = split("/", var.subnet_id)[4]
    virtual_network_name = split("/", var.subnet_id)[8]
    name                 = split("/", var.subnet_id)[10]
  }

  default_machine_learning_workspace_outbound_rules = {
    "${azurerm_storage_account.storage.name}-table" = {
      type     = "PrivateEndpoint"
      category = "UserDefined"
      status   = "Active"
      destination = {
        serviceResourceId = azurerm_storage_account.storage.id
        subresourceTarget = "table"
        sparkEnabled      = true
        sparkStatus       = "Active"
      }
    },
    "${azurerm_storage_account.storage.name}-queue" = {
      type     = "PrivateEndpoint"
      category = "UserDefined"
      status   = "Active"
      destination = {
        serviceResourceId = azurerm_storage_account.storage.id
        subresourceTarget = "queue"
        sparkEnabled      = true
        sparkStatus       = "Active"
      }
    }
  }
  search_service_machine_learning_workspace_outbound_rules = {
    "${azurerm_search_service.search_service.name}-searchService" = {
      type     = "PrivateEndpoint"
      category = "UserDefined"
      status   = "Active"
      destination = {
        serviceResourceId = azurerm_search_service.search_service.id
        subresourceTarget = "searchService"
        sparkEnabled      = true
        sparkStatus       = "Active"
      }
    }
  }
  machine_learning_workspace_outbound_rules = var.search_service_enabled ? merge(local.default_machine_learning_workspace_outbound_rules, local.search_service_machine_learning_workspace_outbound_rules) : local.default_machine_learning_workspace_outbound_rules
}
