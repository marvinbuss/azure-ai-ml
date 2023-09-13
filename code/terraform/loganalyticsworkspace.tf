resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${local.prefix}-log001"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  tags                = var.tags

  allow_resource_only_permissions = true
  cmk_for_query_forced            = false
  daily_quota_gb                  = -1
  internet_ingestion_enabled      = true
  internet_query_enabled          = true
  local_authentication_disabled   = true
  retention_in_days               = 30
  sku                             = "PerGB2018"
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_log_analytics_workspace" {
  resource_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_log_analytics_workspace" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_log_analytics_workspace.log_analytics_workspace.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_log_analytics_workspace.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_log_analytics_workspace.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}
