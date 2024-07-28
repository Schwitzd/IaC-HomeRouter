## Services - Locals
locals {
  disable_service = {
    "ftp"    = 21,
    "telnet" = 23,
    "winbox" = 8291
  }
  enable_service = {
    "ssh" = 22
  }
}

/*
resource "routeros_ip_service" "disabled" {
  for_each = local.disable_service
  numbers  = each.key
  port     = each.value
  disabled = true
}

*/
