
resource "routeros_interface_bridge_vlan" "network_vlans" {
  for_each = { for k, v in local.networks : k => v if v.vlan_id != null }

  vlan_ids = [each.value.vlan_id]
  comment  = "vlan-${each.key}"
  bridge   = each.value.bridge
  tagged   = each.value.vlan_interface
}

resource "routeros_interface_vlan" "vlans" {
  for_each = { for k, v in local.networks_static : k => v if v.vlan_id != null }

  interface = each.value.bridge
  name      = "vlan-${each.value.name}"
  arp       = "enabled"
  vlan_id   = each.value.vlan_id
}