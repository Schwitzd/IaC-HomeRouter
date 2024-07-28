# WiFi
resource "routeros_wifi" "network_wifi" {
  for_each = local.wifi_settings

  arp_timeout = each.value.arp_timeout
  channel = {
    band                = lookup(each.value, "band", null)
    frequency           = lookup(each.value, "frequency", null)
    reselect_interval   = each.value.reselect_interval
    secondary_frequency = lookup(each.value, "secondary_frequency", null)
    skip_dfs_channels   = "10min-cac"
    width               = lookup(each.value, "width", null)
  }
  configuration = {
    country = "Switzerland"
    mode    = "ap"
    ssid    = each.value.ssid
  }
  datapath = {
    vlan_id = each.value.vlan_id
  }
  disabled    = false
  l2mtu       = 1560
  mac_address = each.value.mac_address
  name        = each.value.name
  security = {
    authentication_types = each.value.authentication_types
    connect_priority     = "0"
    ft                   = "true"
    ft_over_ds           = "true"
    passphrase           = each.value.passphrase_key
    wps                  = "disable"
  }
}