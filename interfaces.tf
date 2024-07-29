## Interfaces - Locals
locals {
  lan_interface_list = ["bridge", "vlan-myhome", "vlan-myiot"]
  interface_lists = {
    lan = {
      comment = "LAN interfaces"
      name    = "LAN"
    }
    wan = {
      comment = "WAN interface"
      name    = "WAN"
    }
  }

}

# Interfaces
resource "routeros_interface_list" "interfaces" {
  for_each = local.interface_lists
  
  comment = each.value.comment
  name    = each.value.name
}

resource "routeros_interface_list_member" "lan-list_member" {
  for_each  = toset(local.lan_interface_list)
  interface = each.value
  list      = local.interface_lists.lan.name
}