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
    },
    "anaconda001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "anaconda.com"
      status      = "Active"
    },
    "anaconda002" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.anaconda.com"
      status      = "Active"
    },
    "anaconda003" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.anaconda.org"
      status      = "Active"
    },
    "pypi001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "pypi.org"
      status      = "Active"
    },
    "r001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "cloud.r-project.org"
      status      = "Active"
    },
    "pytorch001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.pytorch.org"
      status      = "Active"
    },
    "tensorflow001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.tensorflow.org"
      status      = "Active"
    },
    "vscode001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "update.code.visualstudio.com"
      status      = "Active"
    },
    "vscode002" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.vo.msecnd.net"
      status      = "Active"
    },
    "vscode003" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "marketplace.visualstudio.com"
      status      = "Active"
    },
    "vscode004" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "vscode.blob.core.windows.net"
      status      = "Active"
    },
    "vscode005" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.gallerycdn.vsassets.io"
      status      = "Active"
    },
    "vscode006" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "raw.githubusercontent.com/microsoft/vscode-tools-for-ai/master/azureml_remote_websocket_server/*"
      status      = "Active"
    },
    "maven001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.maven.org"
      status      = "Active"
    },
    "openai001" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "openaipublic.blob.core.windows.net"
      status      = "Active"
    }
  }
  search_service_machine_learning_workspace_outbound_rules = {
    "${azurerm_search_service.search_service[0].name}-searchService" = {
      type     = "PrivateEndpoint"
      category = "UserDefined"
      status   = "Active"
      destination = {
        serviceResourceId = azurerm_search_service.search_service[0].id
        subresourceTarget = "searchService"
        sparkEnabled      = true
        sparkStatus       = "Active"
      }
    }
  }
}
