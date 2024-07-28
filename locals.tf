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
      name    = "myhome"
      network = "192.168.12.0"
      mask    = "24"
      gateway = "192.168.12.1"
      vlan_id = 100
    }
    myiot = {
      name    = "myiot"
      network = "192.168.13.0"
      mask    = "26"
      gateway = "192.168.13.1"
      vlan_id = 200
    }
  }

  networks = {
    myhome = {
      address      = "${local.networks_static.myhome.gateway}/${local.networks_static.myhome.mask}"
      gateway      = local.networks_static.myhome.gateway
      interface    = "vlan-${local.networks_static.myhome.name}"
      dhcp_address = "${local.networks_static.myhome.network}/${local.networks_static.myhome.mask}"
      dhcp_pool    = "dhcp-${local.networks_static.myhome.name}"
      dhcp_dns     = [local.networks_static.myhome.gateway]
      dhcp_gateway = local.networks_static.myhome.gateway
      pool_range   = ["192.168.12.10-192.168.12.254"]
      network      = local.networks_static.myhome.network
    }
    myiot = {
      address      = "${local.networks_static.myiot.gateway}/${local.networks_static.myiot.mask}"
      gateway      = local.networks_static.myiot.gateway
      interface    = "vlan-${local.networks_static.myiot.name}"
      dhcp_address = "${local.networks_static.myiot.network}/${local.networks_static.myiot.mask}"
      dhcp_pool    = "dhcp-${local.networks_static.myiot.name}"
      dhcp_dns     = [local.networks_static.myiot.gateway]
      dhcp_gateway = local.networks_static.myiot.gateway
      pool_range   = ["192.168.13.10-192.168.13.20"]
      network      = local.networks_static.myiot.network
    }
  }
}
