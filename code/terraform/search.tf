resource "azurerm_search_service" "search_service" {
  count = var.search_service_enabled ? 1 : 0

  name                = "${local.prefix}-srch001"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_cs.name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  allowed_ips                              = []
  authentication_failure_mode              = "http403"
  customer_managed_key_enforcement_enabled = false
  hosting_mode                             = "default"
  local_authentication_enabled             = true
  partition_count                          = 1
  public_network_access_enabled            = false
  replica_count                            = 1
  sku                                      = "standard"
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_search_service" {
  count = var.search_service_enabled ? 1 : 0

  resource_id = azurerm_search_service.search_service[0].id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_search_service" {
  count = var.search_service_enabled ? 1 : 0

  name                       = "logAnalytics"
  target_resource_id         = azurerm_search_service.search_service[0].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_search_service[0].log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_search_service[0].metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}

resource "azurerm_private_endpoint" "search_service_private_endpoint" {
  count = var.search_service_enabled ? 1 : 0

  name                = "${azurerm_search_service.search_service[0].name}-pe"
  location            = var.location
  resource_group_name = azurerm_search_service.search_service[0].resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_search_service.search_service[0].name}-nic"
  private_service_connection {
    name                           = "${azurerm_search_service.search_service[0].name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_search_service.search_service[0].id
    subresource_names              = ["searchService"]
  }
  subnet_id = data.azurerm_subnet.subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_search_service == "" ? [] : [1]
    content {
      name = "${azurerm_search_service.search_service[0].name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_search_service
      ]
    }
  }
  lifecycle {
    ignore_changes = [
      private_dns_zone_group
    ]
  }
}
