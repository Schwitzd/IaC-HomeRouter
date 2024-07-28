locals {
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
}
