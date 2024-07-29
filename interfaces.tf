## Interfaces - Locals
locals {
  lan_interface_list = ["bridge", "vlan-myhome", "vlan-myiot"]
}

# Interfaces
resource "routeros_interface_list" "lan" {
  comment = "defconf"
  name    = "LAN"
}

resource "routeros_interface_list_member" "lan-list_member" {
  for_each  = toset(local.lan_interface_list)
  interface = each.value
  list      = routeros_interface_list.lan.name
}