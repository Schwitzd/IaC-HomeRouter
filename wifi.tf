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
resource "routeros_wifi" "myhome" {
  arp_timeout = "auto"
  channel = {
    band                = "5ghz-ax"
    frequency           = "5490-5710"
    reselect_interval   = "1h"
    secondary_frequency = "disabled"
    skip_dfs_channels   = "10min-cac"
    width               = "20/40/80mhz"
  }
  configuration = {
    country = "Switzerland"
    mode    = "ap"
    ssid    = var.wifi_ssid_myhome
  }
  datapath = {
    vlan_id = local.networks_static.myhome.vlan_id
  }
  disabled    = false
  l2mtu       = 1560
  mac_address = "78:9A:18:9F:3F:C4"
  name        = "wifi-myhome"
  security = {
    authentication_types = "wpa2-psk,wpa3-psk"
    connect_priority     = "0"
    ft                   = "true"
    ft_over_ds           = "true"
    passphrase           = data.vault_generic_secret.wifi.data["myhome"]
    wps                  = "disable"
  }
}

resource "routeros_wifi" "myiot" {
  arp_timeout = "auto"
  channel = {
    reselect_interval = "1h"
    skip_dfs_channels = "10min-cac"
  }
  configuration = {
    mode = "ap"
    ssid = var.wifi_ssid_myiot
  }
  datapath = {
    vlan_id = local.networks_static.myiot.vlan_id
  }
  disabled    = false
  l2mtu       = 1560
  mac_address = "78:9A:18:9F:3F:C5"
  name        = "wifi-myiot"
  security = {
    authentication_types = "wpa2-psk,wpa3-psk"
    connect_priority     = "0"
    ft                   = "true"
    ft_over_ds           = "true"
    passphrase           = data.vault_generic_secret.wifi.data["myiot"]
  }
}
