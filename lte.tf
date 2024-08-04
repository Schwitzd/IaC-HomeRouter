resource "routeros_interface_lte" "lte" {
  allow_roaming = false
  apn_profiles  = "default"
  band          = []
  disabled      = false
  mtu           = "1500"
  name          = "lte1"
  #  network_mode  = ["3g", "lte"]
  sms_protocol = null
  # sms_read
}
