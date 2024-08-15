## Services - Locals
locals {
  services = {
    "ftp"     = { port = 21, disabled = true  }
    "telnet"  = { port = 23, disabled = true  }
    "winbox"  = { port = 8291, disabled = true }
    "api"     = { port = 8728, disabled = true }
    "api-ssl" = { port = 8729, disabled = true }
    "www"     = { port = 80, disabled = true  }
    "ssh"     = { port = 22, disabled = false }
    "www-ssl" = { port = 443, disabled = false }
  }
}

# Services
resource "routeros_ip_service" "services" {
  for_each = local.services

  numbers  = each.key
  port     = each.value.port
  disabled = each.value.disabled

  depends_on = [ routeros_container.lego ]
}
