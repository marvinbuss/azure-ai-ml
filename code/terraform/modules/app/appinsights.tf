resource "azurerm_application_insights" "application_insights" {
  name                = module.naming.application_insights.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  application_type                      = "other"
  daily_data_cap_notifications_disabled = false
  disable_ip_masking                    = false
  force_customer_storage_for_profiler   = false
  internet_ingestion_enabled            = true
  internet_query_enabled                = true
  local_authentication_disabled         = false # Can be switched once AAD auth is supported by Open Telemetry
  retention_in_days                     = 90
  sampling_percentage                   = 100
  workspace_id                          = var.log_analytics_workspace_id
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_application_insights" {
  resource_id = azurerm_application_insights.application_insights.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_application_insights" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_application_insights.application_insights.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_application_insights.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_application_insights.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}
