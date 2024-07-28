module "vault-engine" {
  source = "git::https://github.com/Schwitzd/terraform-modules.git//vault-engine"

  vault_address     = var.vault_address
  vault_token       = var.vault_token
  vault_path        = var.vault_path
  vault_description = var.vault_description
  vault_type        = var.vault_type
}

module "vault-policy" {
  source = "git::https://github.com/Schwitzd/terraform-modules.git//vault-policy"

  vault_address = var.vault_address
  vault_token   = var.vault_token
  policy_name   = local.policy_name
  policy_rules  = local.policy_rules
}

module "vault-entity" {
  source = "git::https://github.com/Schwitzd/terraform-modules.git//vault-entity"

  vault_address      = var.vault_address
  vault_token        = var.vault_token
  entity_name        = var.entity_name
  entity_description = var.entity_description
}

module "vault-entity-alias" {
  source = "git::https://github.com/Schwitzd/terraform-modules.git//vault-entity-alias"

  vault_address     = var.vault_address
  vault_token       = var.vault_token
  auth_backend      = var.auth_backend
  entity_alias_name = local.entity_alias_name
  canonical_id      = module.vault-entity.id
}

module "vault_identity_group" {
  source = "git::https://github.com/Schwitzd/terraform-modules.git//vault-identity-group"

  vault_address     = var.vault_address
  vault_token       = var.vault_token
  group_name        = local.group_name
  group_description = var.group_description
  group_type        = var.group_type
  member_entity_ids = [module.vault-entity.id]
  group_policies    = [module.vault-policy.name]
}

module "vault_token" {
  source = "git::https://github.com/Schwitzd/terraform-modules.git//vault-token"

  vault_address      = var.vault_address
  vault_token        = var.vault_token
  token_display_name = local.token_display_name
  token_no_parent    = var.token_no_parent
  token_renewable    = var.token_renewable
  token_policies     = [module.vault-policy.name]
}
