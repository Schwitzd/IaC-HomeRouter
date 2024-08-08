locals {
  # Define system information
  router_user         = data.vault_generic_secret.mikrotik.data["user"]
  router_password     = data.vault_generic_secret.mikrotik.data["password"]
  system_version      = replace(data.routeros_system_resource.data.version, " (stable)", "")
  system_architecture = data.routeros_system_resource.data.architecture_name

  # Define static network configurations
  networks_static = {
    myhome = {
      name            = "myhome"
      network         = "192.168.12.0"
      mask            = "24"
      gateway         = "192.168.12.1"
      dhcp_enabled    = true
      pool_range      = ["192.168.12.10-192.168.12.254"]
      addr_interface  = "vlan-myhome"
      vlan_id         = 100
      vlan_interfaces = ["wifi-myhome"]
    }
    myiot = {
      name            = "myiot"
      network         = "192.168.13.0"
      mask            = "26"
      gateway         = "192.168.13.1"
      dhcp_enabled    = true
      pool_range      = ["192.168.13.10-192.168.13.20"]
      addr_interface  = "vlan-myiot"
      vlan_id         = 200
      vlan_interfaces = ["wifi-myiot"]
    }
    myserver = {
      name           = "myserver"
      network        = "192.168.14.0"
      mask           = "26"
      gateway        = "192.168.14.1"
      dhcp_enabled   = true
      pool_range     = ["192.168.14.10-192.168.14.15"]
      addr_interface = "vlan-myserver"
      vlan_id        = 300
      #      vlan_interfaces  = null
    }
    mycontainers = {
      name           = "mycontainers"
      network        = "192.168.101.0"
      mask           = "26"
      gateway        = "192.168.101.1"
      dhcp_enabled   = false
      addr_interface = local.bridges.containers.name
      vlan_id        = null
    }
  }

  # Read DNS records from YAML file
  dns_records = yamldecode(file("${path.module}/dns_records.yaml"))["dns_records"]

  # SSH Locals
  router_ssh_key = module.sshkey_admin.public_key_filename

  # Dynamic network configurations
  networks = {
    for network_key, network_value in local.networks_static : network_key => {
      address        = "${network_value.gateway}/${network_value.mask}"
      gateway        = network_value.gateway
      interface      = network_value.addr_interface
      dhcp_enabled   = network_value.dhcp_enabled
      dhcp_address   = "${network_value.network}/${network_value.mask}"
      dhcp_pool      = "dhcp-${network_value.name}"
      dhcp_dns       = [network_value.gateway]
      dhcp_gateway   = network_value.gateway
      pool_range     = lookup(network_value, "pool_range", [])
      network        = network_value.network
      vlan_id        = lookup(network_value, "vlan_id", null)
      vlan_interface = concat(["bridge"], lookup(network_value, "vlan_interfaces", []))
    }
  }
}
