variable "vault_address" {
  description = "The address of the HashiCorp Vault server"
  type        = string
}

variable "vault_token" {
  description = "The authentication token for accessing the HashiCorp Vault server"
  type        = string
  sensitive   = true
}

variable "vault_path" {
  description = "Where the secret backend will be mounted"
  type        = string
}

variable "vault_type" {
  description = "Type of the backend engine"
  type        = string
}

variable "vault_description" {
  description = "Human-friendly description of the Vault"
  type        = string
}

variable "auth_backend" {
  description = "Type of authentication method used to access the Vault"
  type        = string
}

variable "entity_name" {
  description = "Name of the identity entity to create"
  type        = string
}

variable "entity_description" {
  description = "Human-friendly description of the identity"
  type        = string
}

variable "group_description" {
  description = "Human-friendly description of the group"
  type        = string
}

variable "group_type" {
  description = "Type of the group, internal or external"
  type        = string
}

variable "token_renewable" {
  description = "Flag to allow to renew this token"
  type        = bool
}

variable "token_no_parent" {
  description = "Flag to create a token without parent"
  type        = bool
}

