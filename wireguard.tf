locals {
  wg_peers = {
    for p in local.wireguard_peers :
    p.name => p
  }
}

# Wireguard Interface for Route64
resource "routeros_interface_wireguard" "interfaces" {
  for_each = local.wireguard_interfaces

  name        = each.key
  comment     = each.value.comment
  listen_port = each.value.listen_port
  mtu         = 1420

  # Lookup the secret if private_key_secret is defined, else leave null
  private_key = try(
    data.vault_generic_secret.wireguard.data[each.value.private_key_secret],
    null
  )
}

# Wireguard peers
resource "routeros_interface_wireguard_peer" "wireguard" {
  for_each = local.wg_peers

  name                 = each.key
  interface            = each.value.interface
  public_key           = each.value.public_key
  allowed_address      = each.value.allowed_address
  endpoint_address     = lookup(each.value, "endpoint_address", null)
  endpoint_port        = lookup(each.value, "endpoint_port", null)
  persistent_keepalive = lookup(each.value, "persistent_keepalive", null)

  depends_on = [
    routeros_interface_wireguard.interfaces
  ]
}
