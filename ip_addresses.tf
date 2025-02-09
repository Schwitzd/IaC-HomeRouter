# IPv4 Addresses
resource "routeros_ip_address" "ip_addresses" {
  for_each = local.networks

  address   = each.value.address
  comment   = each.key
  disabled  = false
  interface = each.value.interface
  network   = each.value.network

  depends_on = [routeros_interface_vlan.vlans]
}

# IPv6 Addresses
resource "routeros_ipv6_address" "ipv6_addresses" {
  for_each = { for k, v in local.networks : k => v if v.ipv6_network != null }

  address   = "${each.value.ipv6_network}1/${each.value.ipv6_mask}"
  comment   = each.key
  interface = each.value.interface
  advertise = true

  depends_on = [routeros_interface_vlan.vlans]
}

# IPv6 Router Advertisements (RA) with RDNSS for DNS
resource "routeros_ipv6_neighbor_discovery" "slaac" {
  for_each = { for k, v in local.networks : k => v if v.ipv6_network != null }

  interface                     = each.value.interface
  advertise_dns                 = true # Enables RDNSS for DNS advertisement
  advertise_mac_address         = true
  dns                           = "${each.value.ipv6_network}1"
  disabled                      = false
  managed_address_configuration = false # No DHCPv6, pure SLAAC
  mtu                           = 1500
  other_configuration           = true # Allows RDNSS
  ra_delay                      = "3s"
  ra_preference                 = "medium"
}
