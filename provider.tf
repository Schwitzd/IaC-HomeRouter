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
  hosturl  = "http://${var.router_ip}:80"
  username = local.router_user
  password = local.router_password
}

provider "local" {}