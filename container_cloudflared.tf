# Container ddns - Locals
locals {
  cloudflared_envs = { for k, v in data.vault_generic_secret.container_cloudflared_envs.data : k => {
    key   = k
    value = v
    }
  }
}

# Container cloudflared - Envs
resource "routeros_container_envs" "cloudflared" {
  for_each = nonsensitive(local.cloudflared_envs)

  name  = "cloudflared"
  key   = each.value.key
  value = each.value.value
}

# Container cloudflared - Image
resource "routeros_container" "cloudflared" {
  remote_image          = "cloudflare/cloudflared:latest"
  interface             = local.veth_interfaces.mycontainer.name
  comment               = "cloudflared Tunnel"
  cmd                   = "tunnel --no-autoupdate run"
  envlist               = "cloudflared"
  dns                   = local.networks_static.mycontainer.dns_server
  logging               = true
  root_dir              = "${local.containers_path}/cloudflared/root"
  start_on_boot         = true
  auto_restart_interval = "30s"

  depends_on = [
    routeros_container_envs.cloudflared
  ]
}
