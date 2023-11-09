resource "azurerm_storage_account" "storage" {
  name                = replace("${local.prefix}-st001", "-", "")
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_ml.name
  tags                = var.tags

  access_tier                     = "Hot"
  account_kind                    = "StorageV2"
  account_replication_type        = "ZRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = false
  allowed_copy_scope              = "AAD"
  blob_properties {
    change_feed_enabled = false
    # change_feed_retention_in_days = 7
    container_delete_retention_policy {
      days = 7
    }
    delete_retention_policy {
      days = 7
    }
    # default_service_version  = "2020-06-12"
    last_access_time_enabled = false
    versioning_enabled       = false
  }
  cross_tenant_replication_enabled = false
  default_to_oauth_authentication  = true
  enable_https_traffic_only        = true
  # immutability_policy {  # Not supported for ADLS Gen2
  #   state                         = "Disabled"
  #   allow_protected_append_writes = true
  #   period_since_creation_in_days = 7
  # }
  infrastructure_encryption_enabled = true
  is_hns_enabled                    = false
  large_file_share_enabled          = false
  min_tls_version                   = "TLS1_2"
  network_rules {
    bypass                     = ["None"]
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
  nfsv3_enabled                 = false
  public_network_access_enabled = true
  queue_encryption_key_type     = "Account"
  table_encryption_key_type     = "Account"
  routing {
    choice                      = "MicrosoftRouting"
    publish_internet_endpoints  = false
    publish_microsoft_endpoints = false
  }
  sftp_enabled              = false
  shared_access_key_enabled = true
}

resource "azurerm_private_endpoint" "storage_private_endpoint_blob" {
  name                = "${azurerm_storage_account.storage.name}-blob-pe"
  location            = var.location
  resource_group_name = azurerm_storage_account.storage.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_storage_account.storage.name}-blob-nic"
  private_service_connection {
    name                           = "${azurerm_storage_account.storage.name}-blob-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["blob"]
  }
  subnet_id = data.azurerm_subnet.subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_blob == "" ? [] : [1]
    content {
      name = "${azurerm_storage_account.storage.name}-blob-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_blob
      ]
    }
  }
  lifecycle {
    ignore_changes = [
      private_dns_zone_group
    ]
  }
}

resource "azurerm_private_endpoint" "storage_private_endpoint_file" {
  name                = "${azurerm_storage_account.storage.name}-file-pe"
  location            = var.location
  resource_group_name = azurerm_storage_account.storage.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_storage_account.storage.name}-file-nic"
  private_service_connection {
    name                           = "${azurerm_storage_account.storage.name}-file-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["file"]
  }
  subnet_id = data.azurerm_subnet.subnet.id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_file == "" ? [] : [1]
    content {
      name = "${azurerm_storage_account.storage.name}-file-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_file
      ]
    }
  }
  lifecycle {
    ignore_changes = [
      private_dns_zone_group
    ]
  }
}
