## DHCP - Locals
locals {
  dhcp_static_hosts = {
    for host in local.static_hosts :
    host.hostname => {
      address     = host.ip
      mac_address = host.mac
      dhcp_server = lookup({ for k, v in local.networks : v.network => v.dhcp_server }, "${join(".", slice(split(".", host.ip), 0, 3))}.0", null)
    }
    if contains(keys(host), "mac")
  }
}

## DHCP - Server
resource "routeros_ip_dhcp_server" "dhcp_servers" {
  for_each = { for k, v in local.networks : k => v if v.dhcp_enabled }

  address_pool = each.value.dhcp_pool
  interface    = each.value.interface
  lease_time   = "30m"
  name         = each.value.dhcp_server
  use_radius   = "no"

  depends_on = [routeros_interface_vlan.vlans, routeros_ip_address.ip_addresses]
}

## DHCP - Networks
resource "routeros_ip_dhcp_server_network" "dhcp_server_networks" {
  for_each = { for k, v in local.networks : k => v if v.dhcp_enabled }

  address    = each.value.dhcp_address
  comment    = each.value.dhcp_pool
  dns_server = each.value.dhcp_dns
  gateway    = each.value.dhcp_gateway
}

## DHCP - Static leases
resource "routeros_ip_dhcp_server_lease" "dhcp_leases" {
  for_each = local.dhcp_static_hosts

  mac_address = each.value.mac_address
  address     = each.value.address
  server      = each.value.dhcp_server
}

## IP Pool
resource "routeros_ip_pool" "dhcp_pools" {
  for_each = { for k, v in local.networks : k => v if v.dhcp_enabled }

  name   = each.value.dhcp_pool
  ranges = each.value.pool_range
}
