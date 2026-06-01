# LTE
resource "routeros_interface_lte" "lte" {
  allow_roaming = false
  apn_profiles  = "default"
  band          = []
  disabled      = false
  mtu           = "1500"
  name          = "lte1"
  network_mode  = ["3g", "lte"]
  sms_protocol  = null
  sms_read      = false
}

# LTE APN
resource "routeros_interface_lte_apn" "yallo" {
  add_default_route      = true
  apn                    = "internet"
  authentication         = "none"
  default_route_distance = 2
  ip_type                = "auto"
  ipv6_interface         = "bridge"
  name                   = "default"
  use_network_apn        = true
  use_peer_dns           = true
}