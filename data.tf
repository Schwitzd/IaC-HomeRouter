data "vault_generic_secret" "mikrotik" {
  path = "${var.vault_name}/mikrotik"
}

data "vault_generic_secret" "wifi" {
  path = "${var.vault_name}/wifi"
}

data "vault_generic_secret" "container_lego_envs" {
  path = "${var.vault_name}/container_lego_envs"
}

data "routeros_system_resource" "data" {}