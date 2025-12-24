locals {
# Build a flat map of all IPv6 interface addresses (ULA + GUA)
  ipv6_networks = merge(
    {
      for k, v in local.networks :
      "${k}-ula" => {
        interface = v.interface
        address   = "${v.ipv6.ula.prefix64}1/${v.ipv6.ula.mask}"
        advertise = lookup(v.ipv6.ula, "advertise", true)
        comment   = "${k} - ULA"
      }
      if try(v.ipv6.ula.prefix64, null) != null
    },
    {
      for k, v in local.networks :
      "${k}-gua" => {
        interface = v.interface
        address   = "${v.ipv6.gua.prefix64}1/${v.ipv6.gua.mask}"
        advertise = lookup(v.ipv6.gua, "advertise", true)
        comment   = "${k} - GUA"
      }
      if try(v.ipv6.gua.prefix64, null) != null
    }
  )

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
    wg1_router_ula = {
      address   = "fd12:3456:789a:100::1/64"
      comment   = "Wireguard1 inner ULA router address"
      interface = routeros_interface_wireguard.interfaces["wireguard1"].name
      advertise = false
    }
  }

  ipv6_routes = {
    default_route64 = {
      dst_address = "2000::/3"
      gateway     = "wireguard0"
      comment     = "GUA via Route64"
    }
    wg1_inner_ula = {
      dst_address = "fd12:3456:789a:100::/64"
      gateway     = "wireguard1"
      comment     = "Inner wireguard1 network, used only by router (SNAT mode)"

    }
  }
}

# IPv6 Addresses
resource "routeros_ipv6_address" "networks" {
  for_each  = local.ipv6_networks

  interface = each.value.interface
  address   = each.value.address
  advertise = each.value.advertise
  comment   = each.value.comment

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

# IPv6 routes
resource "routeros_ipv6_route" "routes" {
  for_each   = local.ipv6_routes

  dst_address = each.value.dst_address
  gateway     = each.value.gateway
  comment     = each.value.comment
}