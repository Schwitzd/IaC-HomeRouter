locals {
  ipv6_addresses = {
    route64 = {
      address   = var.mikrotik_public_ipv6
      comment   = "Temporary Route64 IPv6 address"
      interface = routeros_interface_wireguard.interfaces["wireguard0"].name
      advertise = false
    }
    home_tunnel = {
      address   = var.wiregard_public_ipv6
      comment   = "Temporary Home tunnel IPv6 address"
      interface = routeros_interface_wireguard.interfaces["wireguard1"].name
      advertise = false
    }
  }
}

# IPv6 Addresses
resource "routeros_ipv6_address" "networks" {
  for_each = { for k, v in local.networks : k => v if v.ipv6_network != null }

  address   = "${each.value.ipv6_network}1/${each.value.ipv6_mask}"
  comment   = each.key
  interface = each.value.interface
  advertise = true

  depends_on = [routeros_interface_vlan.vlans]
}

# Mikrotik temporary IPv6 address thrue Route64
resource "routeros_ipv6_address" "singles" {
  for_each  = local.ipv6_addresses

  address   = each.value.address
  comment   = each.value.comment
  interface = each.value.interface
  advertise = each.value.advertise
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
