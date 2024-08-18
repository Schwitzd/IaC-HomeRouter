# WiFi - Locals
locals {
  wifi_settings = {
    myhome = {
      arp_timeout           = "auto"
      band                  = "5ghz-ax"
      frequency             = "5490-5710"
      reselect_interval     = "1h"
      secondary_frequency   = "disabled"
      width                 = "20/40/80mhz"
      ssid                  = "MyHome_optout_nomap"
      vlan_id               = local.networks_static.myhome.vlan_id
      mac_address           = "78:9A:18:9F:3F:C4"
      name                  = "wifi-myhome"
      passphrase_key        = data.vault_generic_secret.wifi.data["myhome"]
      authentication_types  = "wpa2-psk,wpa3-psk"
      management_encryption = "gmac"
      management_protection = "required"
    }
    myiot = {
      arp_timeout           = "auto"
      reselect_interval     = "1h"
      ssid                  = "MyIoT_optout_nomap"
      vlan_id               = local.networks_static.myiot.vlan_id
      mac_address           = "78:9A:18:9F:3F:C5"
      name                  = "wifi-myiot"
      passphrase_key        = data.vault_generic_secret.wifi.data["myiot"]
      authentication_types  = "wpa2-psk,wpa3-psk"
      management_encryption = "cmac"
      management_protection = "allowed"
    }
  }
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
    authentication_types  = each.value.authentication_types
    connect_priority      = "0"
    ft                    = "true"
    ft_over_ds            = "true"
    passphrase            = each.value.passphrase_key
    management-encryption = each.value.management_encryption
    management_protection = each.value.management_protection
    wps                   = "disable"
  }
}
