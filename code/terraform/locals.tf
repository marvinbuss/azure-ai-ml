locals {
  prefix = "${lower(var.prefix)}-${var.environment}"

  subnet = {
    resource_group_name  = split("/", var.vnet_id)[4]
    virtual_network_name = split("/", var.vnet_id)[8]
    name                 = split("/", var.vnet_id)[10]
  }
}
