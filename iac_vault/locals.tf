locals {
  policy_name = "${var.vault_path}-policy"
}

locals {
  group_name = "${var.vault_path}-group"
}

locals {
  token_display_name = "${var.vault_path}"
}

locals {
  policy_rules = {
    "data" = {
      path         = "${var.vault_path}/data/*",
      capabilities = ["create", "read", "update", "list", "delete"],
      description  = "Vault ${var.vault_path} data policy"
    },
    "metadata" = {
      path         = "${var.vault_path}/metadata/*",
      capabilities = ["create", "read", "update", "list", "delete"],
      description  = "Vault ${var.vault_path} metadata policy"
    }
  }
}

locals {
  entity_alias_name = "${var.entity_name}-${var.auth_backend}"
}