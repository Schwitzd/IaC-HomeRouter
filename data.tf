data "routeros_system_resource" "data" {}

data "vault_generic_secret" "mikrotik" {
  path = "${var.vault_name}/mikrotik"
}

data "vault_generic_secret" "wifi" {
  path = "${var.vault_name}/wifi"
}

data "vault_generic_secret" "wireguard" {
  path = "${var.vault_name}/wireguard"
}

data "vault_generic_secret" "container_lego_envs" {
  path = "${var.vault_name}/container_lego_envs"
}

data "vault_generic_secret" "container_ddns_envs" {
  path = "${var.vault_name}/container_ddns_envs"
}

data "vault_generic_secret" "container_cloudflared_envs" {
  path = "${var.vault_name}/container_cloudflared_envs"
}
