locals {
  disable_service = {
    "ftp"    = 21,
    "telnet" = 23,
    "winbox" = 8291
  }
  enable_service = {
    "ssh" = 22
  }

  lan_interface_list = ["bridge", "vlan-myhome"]

  networks_static = {
    myhome = {
      name       = "myhome"
      network    = "192.168.12.0"
      mask       = "24"
      gateway    = "192.168.12.1"
      pool_range = ["192.168.12.10-192.168.12.254"]
      vlan_id    = 100
    }
    myiot = {
      name       = "myiot"
      network    = "192.168.13.0"
      mask       = "26"
      gateway    = "192.168.13.1"
      pool_range = ["192.168.13.10-192.168.13.20"]
      vlan_id    = 200
    }
  }

  networks = {
    for network_key, network_value in local.networks_static : network_key => {
      address          = "${network_value.gateway}/${network_value.mask}"
      gateway          = network_value.gateway
      interface        = "vlan-${network_value.name}"
      dhcp_address     = "${network_value.network}/${network_value.mask}"
      dhcp_pool        = "dhcp-${network_value.name}"
      dhcp_dns         = [network_value.gateway]
      dhcp_gateway     = network_value.gateway
      pool_range       = network_value.pool_range
      network          = network_value.network
      vlan_id          = network_value.vlan_id
      interface_tagged = ["bridge", "wifi-${network_value.name}"]
    }
  }

  wifi_settings = {
    myhome = {
      arp_timeout         = "auto"
      band                = "5ghz-ax"
      frequency           = "5490-5710"
      reselect_interval   = "1h"
      secondary_frequency = "disabled"
      width               = "20/40/80mhz"
      ssid                = "MyHome_optout_nomap"
      vlan_id             = local.networks_static.myhome.vlan_id
      mac_address         = "78:9A:18:9F:3F:C4"
      name                = "wifi-myhome"
      passphrase_key      = data.vault_generic_secret.wifi.data["myhome"]
      authentication_types = "wpa2-psk,wpa3-psk"
    }
    myiot = {
      arp_timeout          = "auto"
      reselect_interval    = "1h"
      ssid                 = "MyIoT_optout_nomap"
      vlan_id              = local.networks_static.myiot.vlan_id
      mac_address          = "78:9A:18:9F:3F:C5"
      name                 = "wifi-myiot"
      passphrase_key       = data.vault_generic_secret.wifi.data["myiot"]
      authentication_types = "wpa2-psk,wpa3-psk"
    }
  }

  bridge_ports = {
    ether1 = {
      interface = "ether1"
      pvid = 1
    }
    ether2 = {
      interface = "ether2"
      pvid = 1
    }
    ether3 = {
      interface = "ether3"
      pvid = 1
    }
    ether4 = {
      interface = "ether4"
      pvid = 1
    }
    ether5 = {
      interface = "ether5"
      pvid = 1
    }
    wifi1 = {
      interface = local.wifi_settings.myhome.name
      pvid = 100
    }
    wifi2 = {
      interface = local.wifi_settings.myiot.name
      pvid = 200
    }
  }
}
