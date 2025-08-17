# IPv6 Router Advertisements (RA) with RDNSS for DNS
resource "routeros_ipv6_neighbor_discovery" "slaac" {
  for_each = {
    for k, v in local.networks :
    k => v
    if try(v.ipv6, null) != null
  }

  interface                     = each.value.interface
  advertise_mac_address         = true # Enables RDNSS for DNS advertisement
  advertise_dns                 = true
  dns                           = "${try(each.value.ipv6.gua.prefix64, each.value.ipv6.ula.prefix64)}1"
  managed_address_configuration = false # No DHCPv6, pure SLAAC
  other_configuration           = true # Allows RDNSS
  mtu                           = try(each.value.ipv6.gua.mtu, 1500)
  ra_delay                      = "3s"
  ra_preference                 = "medium"
}
