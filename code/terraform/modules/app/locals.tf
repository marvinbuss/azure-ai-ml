locals {
  prefix = "${lower(var.prefix)}-${var.environment}"

  app_settings_base = [
    {
      name  = "APPLICATIONINSIGHTS_CONNECTION_STRING"
      value = azurerm_application_insights.application_insights.connection_string
    },
    {
      name  = "APPINSIGHTS_INSTRUMENTATIONKEY"
      value = azurerm_application_insights.application_insights.instrumentation_key
    },
    {
      name  = "FUNCTIONS_EXTENSION_VERSION"
      value = "~4"
    },
    {
      name  = "FUNCTIONS_WORKER_RUNTIME"
      value = "python"
    },
    {
      name  = "WEBSITE_CONTENTOVERVNET"
      value = "1"
    },
    {
      name  = "WEBSITE_RUN_FROM_PACKAGE"
      value = "0"
    },
    {
      name  = "PYTHON_ENABLE_WORKER_EXTENSIONS"
      value = "1"
    },
    {
      name  = "ENABLE_ORYX_BUILD"
      value = "1"
    },
    {
      name  = "SCM_DO_BUILD_DURING_DEPLOYMENT"
      value = "1"
    },
    {
      name  = "AzureWebJobsStorage__accountName"
      value = module.storage_account.storage_account_name
    }
  ]

  function_ip_security_restrictions = [
    for allowed_service_tag in var.app_allowed_service_tags :
    {
      name      = "Allow${allowed_service_tag.service_tag_name}"
      ipAddress = allowed_service_tag.service_tag_name,
      priority  = allowed_service_tag.priority
      tag       = "ServiceTag",
    }
  ]
}
