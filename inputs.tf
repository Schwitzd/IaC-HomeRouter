variable "vault_url" {
  description = "The Vault address"
  type        = string
}

variable "vault_token" {
  description = "The Vault API token"
  type        = string
  sensitive   = true
}

variable "vault_name" {
  description = "The Vault name"
  type        = string
  sensitive   = true
}