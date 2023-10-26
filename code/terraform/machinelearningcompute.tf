resource "azurerm_machine_learning_compute_cluster" "machine_learning_compute_cluster_image_build" {
  machine_learning_workspace_id = azurerm_machine_learning_workspace.machine_learning_workspace.id
  name                          = local.default_machine_learning_workspace_image_builder_compute_name
  location                      = var.location
  tags                          = var.tags
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.user_assigned_identity.id
    ]
  }

  description        = "Compute Cluster to build container images"
  local_auth_enabled = false
  scale_settings {
    min_node_count                       = 0
    max_node_count                       = 1
    scale_down_nodes_after_idle_duration = "PT30S"
  }
  ssh_public_access_enabled = false
  vm_priority               = "Dedicated"
  vm_size                   = upper("Standard_DS2_v2")

  depends_on = [
    azapi_update_resource.machine_learning_managed_network
  ]
  lifecycle {
    ignore_changes = [
      subnet_resource_id
    ]
  }
  timeouts {
    create = "40m"
  }
}

resource "azurerm_machine_learning_compute_cluster" "machine_learning_compute_cluster" {
  for_each = var.machine_learning_compute_clusters

  machine_learning_workspace_id = azurerm_machine_learning_workspace.machine_learning_workspace.id
  name                          = each.key
  location                      = var.location
  tags                          = var.tags
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.user_assigned_identity.id
    ]
  }

  description        = ""
  local_auth_enabled = false
  scale_settings {
    min_node_count                       = each.value.scale.min_node_count
    max_node_count                       = each.value.scale.max_node_count
    scale_down_nodes_after_idle_duration = each.value.scale.scale_down_nodes_after_idle_duration
  }
  ssh_public_access_enabled = false
  vm_priority               = each.value.vm_priority
  vm_size                   = upper(each.value.vm_size)

  depends_on = [
    azapi_update_resource.machine_learning_managed_network
  ]
  lifecycle {
    ignore_changes = all
  }
  timeouts {
    create = "40m"
  }
}

resource "azurerm_machine_learning_compute_instance" "machine_learning_compute_instance" {
  for_each = var.machine_learning_compute_instances

  machine_learning_workspace_id = azurerm_machine_learning_workspace.machine_learning_workspace.id
  name                          = each.key
  location                      = var.location
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
  authorization_type   = "personal"
  description          = ""
  local_auth_enabled   = false
  virtual_machine_size = upper(each.value.vm_size)

  depends_on = [
    azapi_update_resource.machine_learning_managed_network
  ]
  lifecycle {
    ignore_changes = all
  }
  timeouts {
    create = "40m"
  }
}
