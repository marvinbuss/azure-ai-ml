resource "azurerm_cognitive_account" "cognitive_accounts" {
  for_each = var.cognitive_services

  name                = "${local.prefix}-${each.key}-cog001"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_cs.name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  custom_subdomain_name      = "${local.prefix}-${each.value.kind}-cog001"
  dynamic_throttling_enabled = false
  fqdns = [
    trimsuffix(replace(azurerm_storage_account.storage.primary_blob_endpoint, "https://", ""), "/")
  ]
  kind               = each.value.kind
  local_auth_enabled = true
  network_acls {
    default_action = "Deny"
    ip_rules       = []
  }
  outbound_network_access_restricted = true
  public_network_access_enabled      = false
  sku_name                           = each.value.sku_name
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_cognitive_services" {
  for_each = var.cognitive_services

  resource_id = azurerm_cognitive_account.cognitive_accounts[each.key].id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_cognitive_services" {
  for_each = var.cognitive_services

  name                       = "logAnalytics"
  target_resource_id         = azurerm_cognitive_account.cognitive_accounts[each.key].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_cognitive_services[each.key].log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_cognitive_services[each.key].metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}

resource "azurerm_private_endpoint" "cognitive_services_private_endpoint" {
  for_each = var.cognitive_services

  name                = "${azurerm_cognitive_account.cognitive_accounts[each.key].name}-pe"
  location            = var.location
  resource_group_name = azurerm_cognitive_account.cognitive_accounts[each.key].resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_cognitive_account.cognitive_accounts[each.key].name}-nic"
  private_service_connection {
    name                           = "${azurerm_cognitive_account.cognitive_accounts[each.key].name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_cognitive_account.cognitive_accounts[each.key].id
    subresource_names              = ["account"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_cognitive_services == "" ? [] : [1]
    content {
      name = "${azurerm_cognitive_account.cognitive_accounts[each.key].name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_cognitive_services
      ]
    }
  }
}
