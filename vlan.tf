
resource "routeros_interface_bridge_vlan" "network_vlans" {
  for_each = local.networks

  vlan_ids = [each.value.vlan_id]
  comment  = "vlan-${each.key}"
  bridge   = local.bridges.bridge.name
  tagged   = each.value.vlan_interface
}

resource "routeros_interface_vlan" "vlans" {
  for_each  = local.networks_static

  interface = local.bridges.bridge.name
  name      = "vlan-${each.value.name}"
  arp       = "enabled"
  vlan_id   = each.value.vlan_id
}