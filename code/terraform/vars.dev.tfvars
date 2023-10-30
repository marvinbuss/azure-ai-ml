# General variables
location            = "northeurope"
environment         = "dev"
prefix              = "dpml"
tags                = {}

// ML variables
machine_learning_compute_clusters = {
  # "cpu001" = {
  #   vm_priority = "Dedicated"
  #   vm_size     = "Standard_DS2_v2"
  #   scale = {
  #     min_node_count                       = 0
  #     max_node_count                       = 3
  #     scale_down_nodes_after_idle_duration = "PT30S"
  #   }
  # }
}
machine_learning_compute_instances = {
  # "mabuss" = {
  #   vm_size        = "Standard_DS2_v2"
  #   user_object_id = "540d8186-5d32-4ab6-a962-0d91ba5bd2c2"
  # }
}

// Service enablement variables
open_ai_enabled        = false
search_service_enabled = false
cognitive_services = {
  # "frmrcg" = {
  #   kind     = "FormRecognizer"
  #   sku_name = "S0"
  # }
}

// Network variables
subnet_id                                      = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-logic-network-rg/providers/Microsoft.Network/virtualNetworks/mycrp-prd-logic-vnet001/subnets/PeSubnet"
private_dns_zone_id_blob                       = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
private_dns_zone_id_file                       = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"
private_dns_zone_id_table                      = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.table.core.windows.net"
private_dns_zone_id_queue                      = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.queue.core.windows.net"
private_dns_zone_id_container_registry         = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"
private_dns_zone_id_key_vault                  = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
private_dns_zone_id_machine_learning_api       = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.api.azureml.ms"
private_dns_zone_id_machine_learning_notebooks = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.notebooks.azure.net"
private_dns_zone_id_search_service             = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net"
private_dns_zone_id_open_ai                    = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com"
private_dns_zone_id_cognitive_services         = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com"
data_platform_subscription_ids                 = []
