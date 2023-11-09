resource "azurerm_service_plan" "service_plan" {
  name                = module.naming.app_service_plan.name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_asp.name
  tags                = var.tags

  os_type                  = "Linux"
  per_site_scaling_enabled = false
  sku_name                 = "P1v3"
  worker_count             = 3
  # maximum_elastic_worker_count = 20
  # zone_balancing_enabled   = true  # Not supported in West Europe today
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_service_plan" {
  resource_id = azurerm_service_plan.service_plan.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_service_plan" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_service_plan.service_plan.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_service_plan.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_service_plan.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}
