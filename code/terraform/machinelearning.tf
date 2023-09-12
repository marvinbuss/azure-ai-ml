resource "azurerm_machine_learning_workspace" "machine_learning_workspace" {
  name                = "${local.prefix}-mlw001"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  tags                = var.tags
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.user_assigned_identity.id
    ]
  }

  application_insights_id        = azurerm_application_insights.application_insights.id
  container_registry_id          = azurerm_container_registry.container_registry.id
  key_vault_id                   = azurerm_key_vault.key_vault.id
  storage_account_id             = azurerm_storage_account.storage.id
  description                    = "Azure Machine Learning Workspace for environment ${var.environment} with prefix ${var.prefix}."
  friendly_name                  = title(replace("${local.prefix}-mlw001", "-", " "))
  high_business_impact           = true
  image_build_compute_name       = "imagebuilder001"
  primary_user_assigned_identity = azurerm_user_assigned_identity.user_assigned_identity.id
  public_network_access_enabled  = false
  sku_name                       = "Basic"
  v1_legacy_mode_enabled         = false
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_machine_learning_workspace" {
  resource_id = azurerm_machine_learning_workspace.machine_learning_workspace.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_machine_learning_workspace" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_machine_learning_workspace.machine_learning_workspace.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_setting_machine_learning_workspace.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_setting_machine_learning_workspace.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}

resource "azurerm_private_endpoint" "machine_learning_workspace_private_endpoint" {
  name                = "${azurerm_machine_learning_workspace.machine_learning_workspace.name}-pe"
  location            = var.location
  resource_group_name = azurerm_machine_learning_workspace.machine_learning_workspace.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_machine_learning_workspace.machine_learning_workspace.name}-nic"
  private_service_connection {
    name                           = "${azurerm_machine_learning_workspace.machine_learning_workspace.name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_machine_learning_workspace.machine_learning_workspace.id
    subresource_names              = ["amlworkspace"]
  }
  subnet_id = data.azurerm_subnet.subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_machine_learning_api == "" || var.private_dns_zone_id_machine_learning_notebooks == "" ? [] : [1]
    content {
      name = "${azurerm_machine_learning_workspace.machine_learning_workspace.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_machine_learning_api,
        var.private_dns_zone_id_machine_learning_notebooks
      ]
    }
  }
}
