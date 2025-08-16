# Container ddns - Locals
locals {
  ddns_envs = { for k, v in data.vault_generic_secret.container_ddns_envs.data : k => {
    key   = k
    value = v
    }
  }
}

# Container ddns - Envs
resource "routeros_container_envs" "ddns" {
  for_each = nonsensitive(local.ddns_envs)

  name  = "ddns"
  key   = each.value.key
  value = each.value.value
}

# Container cloudflare-ddns - Image
resource "routeros_container" "ddns" {
  remote_image  = "favonia/cloudflare-ddns:latest"
  interface     = local.veth_interfaces.mycontainer.name
  comment       = "Cloudflare ddns"
  user          = "1000:1000"
  envlist       = "ddns"
  dns           = local.networks_static.mycontainer.dns_server
  logging       = true
  root_dir      = "${local.containers_path}/ddns/root"
  start_on_boot = true

  depends_on = [
    routeros_container_envs.ddns
  ]
}
