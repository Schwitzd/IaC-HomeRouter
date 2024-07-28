## DHCP
resource "routeros_ip_dhcp_server" "dhcp_servers" {
  for_each    = local.networks
  address_pool = each.value.dhcp_pool
  interface    = each.value.interface
  lease_time   = "30m"
  name         = "dhcp-server-${each.key}"
  use_radius   = "no"
}
## DHCP - Networks
resource "routeros_ip_dhcp_server_network" "dhcp_server_networks" {
  for_each   = local.networks
  address    = each.value.dhcp_address
  comment    = each.value.dhcp_pool
  dns_server = each.value.dhcp_dns
  gateway    = each.value.dhcp_gateway
}

## IP Pool
resource "routeros_ip_pool" "dhcp_pools" {
  for_each = local.networks
  name     = each.value.dhcp_pool
  ranges   = each.value.pool_range
}