## Bridge - Locals
locals {
  bridges = {
    bridge = {
      name           = "bridge"
      admin_mac      = "78:9A:18:9F:3F:BF"
      comment        = "Bridge dedicated to generic traffic"
      vlan_filtering = true
    }
    container = {
      name           = "container"
      admin_mac      = "42:E5:EA:3C:1A:F4"
      comment        = "Bridge dedicated to containers traffic"
      vlan_filtering = false
    }
  }

  bridge_ports = {
    ether1 = {
      bridge    = local.bridges.bridge.name
      interface = "ether1"
      pvid      = 300
    }
    ether2 = {
      bridge    = local.bridges.bridge.name
      interface = "ether2"
      pvid      = 300
    }
    ether3 = {
      bridge    = local.bridges.bridge.name
      interface = "ether3"
      pvid      = 1
    }
    ether4 = {
      bridge    = local.bridges.bridge.name
      interface = "ether4"
      pvid      = 1
    }
    ether5 = {
      bridge    = local.bridges.bridge.name
      interface = "ether5"
      pvid      = 1
    }
    wifi1 = {
      bridge    = local.bridges.bridge.name
      interface = local.wifi_settings.myhome.name
      pvid      = 100
    }
    wifi2 = {
      bridge    = local.bridges.bridge.name
      interface = local.wifi_settings.myiot.name
      pvid      = 200
    }
    veth1 = {
      bridge    = local.bridges.container.name
      interface = local.veth_interfaces.mycontainer.name
      pvid      = 1
    }
  }
}

## Bridge
resource "routeros_interface_bridge" "bridges" {
  for_each = local.bridges

  name                = each.value.name
  admin_mac           = each.value.admin_mac
  ageing_time         = "5m"
  arp                 = "enabled"
  arp_timeout         = "auto"
  auto_mac            = false
  comment             = each.value.comment
  dhcp_snooping       = false
  disabled            = false
  fast_forward        = true
  forward_delay       = "15s"
  igmp_snooping       = false
  max_message_age     = "20s"
  mtu                 = "auto"
  mvrp                = false
  port_cost_mode      = "long"
  priority            = "0x8000"
  protocol_mode       = "rstp"
  transmit_hold_count = 6
  vlan_filtering      = each.value.vlan_filtering
}

resource "routeros_interface_bridge_port" "bridge_ports" {
  for_each = local.bridge_ports

  auto_isolate         = false
  bpdu_guard           = false
  bridge               = each.value.bridge
  broadcast_flood      = true
  comment              = null
  disabled             = false
  edge                 = "auto"
  fast_leave           = false
  frame_types          = "admit-all"
  horizon              = "none"
  ingress_filtering    = true
  interface            = each.value.interface
  learn                = "auto"
  multicast_router     = "temporary-query"
  mvrp_applicant_state = "normal-participant"
  mvrp_registrar_state = "normal"
  point_to_point       = "auto"
  pvid                 = each.value.pvid
  #  priority                = "x8000"
  restricted_role         = false
  restricted_tcn          = false
  tag_stacking            = false
  trusted                 = false
  unknown_multicast_flood = true
  unknown_unicast_flood   = true
}
