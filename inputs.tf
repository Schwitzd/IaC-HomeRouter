variable "http_schema" {
  description = "The url connection schema"
  type        = string
}

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

variable "usb_disk" {
  description = "UBS disk path"
  type        = string
}

variable "mikrotik_public_ipv6" {
  description = "Temporary public IPv6 Mikrotik address"
  type        = string
}

variable "wiregard_public_ipv6" {
  description = "Temporary public IPv6 Home tunnel address"
  type        = string
}