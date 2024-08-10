# Locals

locals {
  router_user     = data.vault_generic_secret.mikrotik.data["user"]
  router_password = data.vault_generic_secret.mikrotik.data["password"]
  lego_user       = data.vault_generic_secret.mikrotik.data["user_lego"]
  lego_password   = data.vault_generic_secret.mikrotik.data["password_lego"]

  user_groups = {
    lego = {
      name   = "lego"
      policy = ["!api", "!ftp", "!local", "!password", "!policy", "read", "!reboot", "!rest-api", "!romon", "!sensitive", "!sniff", "ssh", "!telnet", "!test", "!web", "!winbox", "write"]
    }
  }
}

# Groups
resource "routeros_system_user_group" "user_groups" {
  for_each = local.user_groups

  name   = each.value.name
  policy = each.value.policy
}

# Users
resource "routeros_system_user" "lego" {
  name     = local.lego_user
  address  = "${local.networks_static.mycontainers.network}/${local.networks_static.mycontainers.mask}"
  group    = routeros_system_user_group.user_groups["lego"].name
  password = local.lego_password
  comment  = "Used to rotate letsencrypt certificate"

  depends_on = [ routeros_system_user_group.user_groups ]
}
