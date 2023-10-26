resource "azurerm_container_registry" "container_registry" {
  name                = replace("${local.prefix}-acr001", "-", "")
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_ml.name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  admin_enabled              = true
  anonymous_pull_enabled     = false
  data_endpoint_enabled      = false
  export_policy_enabled      = true
  network_rule_bypass_option = "AzureServices"
  network_rule_set = [
    {
      default_action  = "Deny"
      ip_rule         = []
      virtual_network = []
    }
  ]
  public_network_access_enabled = false
  quarantine_policy_enabled     = true
  retention_policy = [
    {
      days    = 7
      enabled = true
    }
  ]
  sku = "Premium"
  trust_policy = [
    {
      enabled = false
    }
  ]
  zone_redundancy_enabled = true
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_container_registry" {
  resource_id = azurerm_container_registry.container_registry.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_container_registry" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_container_registry.container_registry.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_container_registry.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_container_registry.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}

resource "azurerm_private_endpoint" "container_registry_private_endpoint" {
  name                = "${azurerm_container_registry.container_registry.name}-pe"
  location            = var.location
  resource_group_name = azurerm_container_registry.container_registry.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_container_registry.container_registry.name}-nic"
  private_service_connection {
    name                           = "${azurerm_container_registry.container_registry.name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_container_registry.container_registry.id
    subresource_names              = ["registry"]
  }
  subnet_id = data.azurerm_subnet.subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_container_registry == "" ? [] : [1]
    content {
      name = "${azurerm_container_registry.container_registry.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_container_registry
      ]
    }
  }
}
