resource "azurerm_machine_learning_compute_cluster" "machine_learning_compute_cluster" {
  machine_learning_workspace_id = azurerm_machine_learning_workspace.machine_learning_workspace.id
  name                          = "builder001"
  location                      = var.location
  resource_group_name           = data.azurerm_resource_group.resource_group.name
  tags                          = var.tags
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.user_assigned_identity.id
    ]
  }

  description            = "Compute Clutser to build Container Images"
  local_auth_enabled     = false
  node_public_ip_enabled = false
  scale_settings {
    min_node_count = 0
    max_node_count = 1
  }
  ssh_public_access_enabled = false
  vm_priority               = "Dedicated"
  vm_size                   = "Standard_DS2_v2"

  depends_on = [
    azapi_update_resource.machine_learning_managed_network
  ]
}

resource "azurerm_machine_learning_compute_cluster" "machine_learning_compute_cluster" {
  for_each = var.machine_learning_compute_clusters

  machine_learning_workspace_id = azurerm_machine_learning_workspace.machine_learning_workspace.id
  name                          = each.key
  location                      = var.location
  resource_group_name           = data.azurerm_resource_group.resource_group.name
  tags                          = var.tags
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.user_assigned_identity.id
    ]
  }

  description            = ""
  local_auth_enabled     = false
  node_public_ip_enabled = false
  scale_settings {
    min_node_count = each.value.scale.min_node_count
    max_node_count = each.value.scale.max_node_count
  }
  ssh_public_access_enabled = false
  vm_priority               = each.value.vm_priority
  vm_size                   = each.value.vm_size

  depends_on = [
    azapi_update_resource.machine_learning_managed_network
  ]
}

resource "azurerm_machine_learning_compute_instance" "machine_learning_compute_instance" {
  for_each = var.machine_learning_compute_instances

  machine_learning_workspace_id = azurerm_machine_learning_workspace.machine_learning_workspace.id
  name                          = each.key
  location                      = var.location
  resource_group_name           = data.azurerm_resource_group.resource_group.name
  tags                          = var.tags
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.user_assigned_identity.id
    ]
  }

  assign_to_user {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = each.value.user_object_id
  }
  authorization_type     = "personal"
  description            = ""
  local_auth_enabled     = false
  node_public_ip_enabled = false
  virtual_machine_size   = each.value.vm_size

  depends_on = [
    azapi_update_resource.machine_learning_managed_network
  ]
}
