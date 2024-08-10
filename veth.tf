# Locals - vETH
locals {
  veth_interfaces = {
    mycontainer = {
      name    = "veth-${local.networks_static.mycontainer.name}"
      address = "192.168.101.2/${local.networks_static.mycontainer.mask}"
      gateway = local.networks_static.mycontainer.gateway
      comment = "Virtual interface for containers"
    }
  }
}

# vETH
resource "routeros_interface_veth" "veth" {
  for_each = local.veth_interfaces

  name    = each.value.name
  address = each.value.address
  gateway = each.value.gateway
  comment = each.value.comment
}