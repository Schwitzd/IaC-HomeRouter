## Interfaces - Locals
locals {
  lan_interface_list   = ["bridge", "container", "vlan-myhome", "vlan-myiot", "vlan-myserver"]
  vlans_interface_list = ["vlan-myhome", "vlan-myiot", "vlan-myserver"]
  interface_lists = {
    lan = {
      comment = "LAN interfaces"
      name    = "LAN"
    }
    vlans = {
      comment = "List of all VLANs"
      name    = "VLANs"
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

  depends_on = [ routeros_interface_list.interfaces ]
}

resource "routeros_interface_list_member" "vlans-list_member" {
  for_each  = toset(local.vlans_interface_list)
  interface = each.value
  list      = local.interface_lists.vlans.name

  depends_on = [ routeros_interface_list.interfaces ]
}
