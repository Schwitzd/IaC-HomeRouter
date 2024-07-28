resource "routeros_interface_bridge_vlan" "myhome" {
  vlan_ids = ["100"]
  comment  = "myhome"
  bridge   = "bridge"
  tagged = [
    "bridge",
    "wifi-myhome"
  ]
}

resource "routeros_interface_bridge_vlan" "myiot" {
  vlan_ids = ["200"]
  comment  = "myiot"
  bridge   = "bridge"
  tagged = [
    "bridge",
    "wifi-myiot"
  ]
}

resource "routeros_interface_vlan" "vlans" {
  for_each  = local.networks_static
  interface = "bridge"
  name      = "vlan-${each.value.name}"
  arp       = "enabled"
  vlan_id   = each.value.vlan_id
}