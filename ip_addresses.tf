# IP Addresses
resource "routeros_ip_address" "ip_addresses" {
  for_each  = local.networks

  address   = each.value.address
  comment   = each.key
  disabled  = false
  interface = each.value.interface
  network   = each.value.network

  depends_on = [ routeros_interface_vlan.vlans ]
}