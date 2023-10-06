locals {
  prefix = "${lower(var.prefix)}-${var.environment}"

  subnet = {
    resource_group_name  = split("/", var.subnet_id)[4]
    virtual_network_name = split("/", var.subnet_id)[8]
    name                 = split("/", var.subnet_id)[10]
  }

  default_machine_learning_workspace_image_builder_compute_name = "imagebuilder001"
  default_machine_learning_workspace_outbound_rules = {
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
      destination = "pytorch.org"
      status      = "Active"
    },
    "pytorch002" = {
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
      destination = "raw.githubusercontent.com" // "/microsoft/vscode-tools-for-ai/master/azureml_remote_websocket_server/*"
      status      = "Active"
    },
    "vscode007" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.vscode.dev"
      status      = "Active"
    },
    "vscode008" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.vscode-cdn.net"
      status      = "Active"
    },
    "vscode009" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "*.vscodeexperiments.azureedge.net"
      status      = "Active"
    },
    "vscode010" = {
      type        = "FQDN"
      category    = "UserDefined"
      destination = "default.exp-tas.com"
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
    },
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
    "${var.search_service_enabled ? azurerm_search_service.search_service[0].name : ""}-searchService" = {
      type     = "PrivateEndpoint"
      category = "UserDefined"
      status   = "Active"
      destination = {
        serviceResourceId = var.search_service_enabled ? azurerm_search_service.search_service[0].id : ""
        subresourceTarget = "searchService"
        sparkEnabled      = true
        sparkStatus       = "Active"
      }
    }
  }
  open_ai_machine_learning_workspace_outbound_rules = {
    "${var.open_ai_enabled ? azurerm_cognitive_account.cognitive_account[0].name : ""}-account" = {
      type     = "PrivateEndpoint"
      category = "UserDefined"
      status   = "Active"
      destination = {
        serviceResourceId = var.open_ai_enabled ? azurerm_cognitive_account.cognitive_account[0].id : ""
        subresourceTarget = "account"
        sparkEnabled      = true
        sparkStatus       = "Active"
      }
    }
  }
  machine_learning_workspace_outbound_rules = merge(local.default_machine_learning_workspace_outbound_rules, var.search_service_enabled ? local.search_service_machine_learning_workspace_outbound_rules : {}, var.open_ai_enabled ? local.open_ai_machine_learning_workspace_outbound_rules : {})
}
