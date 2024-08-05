data "vault_generic_secret" "mikrotik" {
  path = "${var.vault_name}/mikrotik"
}

data "vault_generic_secret" "wifi" {
  path = "${var.vault_name}/wifi"
}

data "routeros_system_resource" "data" {}