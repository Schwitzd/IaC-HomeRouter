terraform {
  required_providers {
    routeros = {
      source = "terraform-routeros/routeros"
    }
  }
  required_version = ">= 0.13"
}

provider "vault" {
  address          = var.vault_url
  token            = var.vault_token
  skip_child_token = true
}

provider "routeros" {
  hosturl  = "${var.http_schema}://${local.router_hostname}"
  username = local.router_user
  password = local.router_password
  insecure = var.http_schema == "https" ? false : true
}

provider "local" {}