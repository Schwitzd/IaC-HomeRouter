## WiFi Interface

resource "routeros_interface_bridge_port" "wifi1" {
  auto_isolate            = false
  bpdu_guard              = false
  bridge                  = routeros_interface_bridge.bridge.name
  broadcast_flood         = true
  comment                 = "defconf"
  disabled                = false
  edge                    = "auto"
  fast_leave              = false
  frame_types             = "admit-all"
  horizon                 = "none"
  ingress_filtering       = true
  interface               = "wifi-myhome"
  learn                   = "auto"
  multicast_router        = "temporary-query"
  mvrp_applicant_state    = "normal-participant"
  mvrp_registrar_state    = "normal"
  point_to_point          = "auto"
  restricted_role         = false
  restricted_tcn          = false
  tag_stacking            = false
  trusted                 = false
  unknown_multicast_flood = true
  unknown_unicast_flood   = true
}

resource "routeros_interface_bridge_port" "wifi2" {
  auto_isolate         = false
  bpdu_guard           = false
  bridge               = routeros_interface_bridge.bridge.name
  broadcast_flood      = true
  comment              = "defconf"
  disabled             = false
  edge                 = "auto"
  fast_leave           = false
  frame_types          = "admit-all"
  horizon              = "none"
  ingress_filtering    = true
  interface            = "wifi-myiot"
  learn                = "auto"
  multicast_router     = "temporary-query"
  mvrp_applicant_state = "normal-participant"
  mvrp_registrar_state = "normal"
  point_to_point       = "auto"
  restricted_role         = false
  restricted_tcn          = false
  tag_stacking            = false
  trusted                 = false
  unknown_multicast_flood = true
  unknown_unicast_flood   = true
}

# WiFi
resource "routeros_wifi" "network_wifi" {
  for_each = local.wifi_settings

  arp_timeout = each.value.arp_timeout
  channel = {
    band                = lookup(each.value, "band", null)
    frequency           = lookup(each.value, "frequency", null)
    reselect_interval   = each.value.reselect_interval
    secondary_frequency = lookup(each.value, "secondary_frequency", null)
    skip_dfs_channels   = each.value.skip_dfs_channels
    width               = lookup(each.value, "width", null)
  }
  configuration = {
    country = each.value.country
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
    authentication_types = "wpa2-psk,wpa3-psk"
    connect_priority     = "0"
    ft                   = "true"
    ft_over_ds           = "true"
    passphrase           = each.value.passphrase_key
    wps                  = "disable"
  }
}