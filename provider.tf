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
  hosturl  = "http://192.168.88.1:80"
  username = data.vault_generic_secret.mikrotik.data["user"]
  password = data.vault_generic_secret.mikrotik.data["password"]
}