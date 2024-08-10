# Container Lego - Locals

locals {
  lego_envs = { for k, v in data.vault_generic_secret.container_lego_envs.data : k => {
    key   = k
    value = v
  } }

  lego_mounts = {
    lego-sshkey = {
      src = "/usb1/containers/lego/ssh"
      dst = "/ssh"
    }
    lego-letsencrypt = {
      src = "/usb1/containers/lego/data"
      dst = "/letsencrypt"
    }
  }
}

# Container Lego - Envs
resource "routeros_container_envs" "lego_envs" {
  for_each = nonsensitive(local.lego_envs)

  name  = "lego"
  key   = each.value.key
  value = each.value.value
}

# Container Lego - Mounts
resource "routeros_container_mounts" "lego_mounts" {
  for_each = local.lego_mounts

  name = each.key
  src  = each.value.src
  dst  = each.value.dst
}

# Container Lego - Image

resource "routeros_container" "lego" {
  remote_image  = "schwitzd/routeros-letsencrypt"
  interface     = local.veth_interfaces.mycontainers.name
  envlist       = "lego"
  logging       = true
  mounts        = [for mount in routeros_container_mounts.lego_mounts : mount.name]
  root_dir      = "${local.containers_path}/lego/root"
  user          = "lego"
  start_on_boot = true

  depends_on = [routeros_container_mounts.lego_mounts, routeros_container_envs.lego_envs]
}
