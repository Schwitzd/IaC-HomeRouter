# Users - Locals
locals {
  router_user     = data.vault_generic_secret.mikrotik.data["user"]
  router_password = data.vault_generic_secret.mikrotik.data["password"]

  users_data = {
    lego = {
      user            = data.vault_generic_secret.mikrotik.data["user_lego"]
      password        = data.vault_generic_secret.mikrotik.data["password_lego"]
      allowed_address = "${local.networks_static.mycontainer.network}/${local.networks_static.mycontainer.mask}"
      group           = "lego"
      comment         = "Used to rotate letsencrypt certificate"
      policy          = ["!api", "ftp", "!local", "!password", "!policy", "read", "!reboot", "!rest-api", "!romon", "!sensitive", "!sniff", "ssh", "!telnet", "!test", "!web", "!winbox", "write"]
    },
    mktxp = {
      user            = data.vault_generic_secret.mikrotik.data["user_mktxp"]
      password        = data.vault_generic_secret.mikrotik.data["password_mktxp"]
      allowed_address = "${local.networks_static.myserver.network}/${local.networks_static.myserver.mask}"
      group           = "mktxp"
      comment         = "Used to monitor MikroTik router"
      policy          = ["api", "!ftp", "!local", "!password", "!policy", "read", "!reboot", "!rest-api", "!romon", "!sensitive", "!sniff", "!ssh", "!telnet", "!test", "!web", "!winbox", "!write"]
    }
  }
}

# User Groups
resource "routeros_system_user_group" "user_groups" {
  for_each = local.users_data

  name   = each.value.group
  policy = each.value.policy
}

# Users
resource "routeros_system_user" "users" {
  for_each = local.users_data

  name     = each.value.user
  address  = each.value.allowed_address
  group    = routeros_system_user_group.user_groups[each.key].name
  password = each.value.password
  comment  = each.value.comment

  depends_on = [routeros_system_user_group.user_groups]
}
