variable "router_ip" {
  description = "The Mikdrotik router IP addess"
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