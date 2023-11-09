resource "azapi_resource" "app" {
  type      = "Microsoft.Web/sites@2022-09-01"
  parent_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  name      = module.naming.function_app.name
  location  = var.location
  tags      = var.tags
  identity {
    type = "SystemAssigned"
  }

  body = jsonencode({
    kind = "linux"
    properties = {
      clientAffinityEnabled     = false
      clientCertEnabled         = false
      clientCertMode            = "Required"
      enabled                   = true
      hostNamesDisabled         = false
      httpsOnly                 = true
      hyperV                    = false
      isXenon                   = false
      keyVaultReferenceIdentity = "SystemAssigned"
      publicNetworkAccess       = length(var.app_allowed_service_tags) > 0 ? "Enabled" : "Disabled"
      redundancyMode            = "None"
      reserved                  = true
      scmSiteAlsoStopped        = false
      serverFarmId              = var.app_service_plan_id
      storageAccountRequired    = false
      vnetContentShareEnabled   = true
      virtualNetworkSubnetId    = var.app_subnet_id
      vnetRouteAllEnabled       = true
      siteConfig = {
        autoHealEnabled                        = false
        acrUseManagedIdentityCreds             = false
        alwaysOn                               = true
        appSettings                            = setunion(local.app_settings_base, var.app_settings)
        azureStorageAccounts                   = {}
        detailedErrorLoggingEnabled            = true
        functionAppScaleLimit                  = 0
        functionsRuntimeScaleMonitoringEnabled = false
        ftpsState                              = "Disabled"
        healthCheckPath                        = var.app_health_path != "" ? var.app_health_path : null
        http20Enabled                          = true
        ipSecurityRestrictionsDefaultAction    = "Deny"
        ipSecurityRestrictions                 = length(var.app_allowed_service_tags) > 0 ? local.function_ip_security_restrictions : []
        linuxFxVersion                         = "${var.app_runtime}|${var.app_runtime_version}"
        localMySqlEnabled                      = false
        loadBalancing                          = "LeastRequests"
        minTlsVersion                          = "1.2"
        minTlsCipherSuite                      = "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
        minimumElasticInstanceCount            = 0
        numberOfWorkers                        = 1
        preWarmedInstanceCount                 = 0
        scmMinTlsVersion                       = "1.2"
        scmIpSecurityRestrictionsUseMain       = false
        scmIpSecurityRestrictionsDefaultAction = "Deny"
        use32BitWorkerProcess                  = true
        vnetPrivatePortsCount                  = 0
        webSocketsEnabled                      = false
      }
    }
  })

  schema_validation_enabled = false
  depends_on = [
    module.storage_account.storage_setup_completed
  ]
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_function" {
  resource_id = azapi_resource.app.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_function" {
  name                       = "logAnalytics"
  target_resource_id         = azapi_resource.app.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_function.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_function.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}

resource "azurerm_private_endpoint" "function_private_endpoint" {
  name                = "${azapi_resource.app.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azapi_resource.app.name}-nic"
  private_service_connection {
    name                           = "${azapi_resource.app.name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azapi_resource.app.id
    subresource_names              = ["sites"]
  }
  subnet_id = var.private_endpoint_subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_sites == "" ? [] : [1]
    content {
      name = "${azapi_resource.app.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_sites
      ]
    }
  }
  lifecycle {
    ignore_changes = [
      private_dns_zone_group
    ]
  }
}
