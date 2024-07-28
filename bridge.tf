## Bridge
resource "routeros_interface_bridge" "bridge" {
  admin_mac           = "78:9A:18:9F:3F:BF"
  ageing_time         = "5m"
  arp                 = "enabled"
  arp_timeout         = "auto"
  auto_mac            = false
  comment             = "defconf"
  dhcp_snooping       = false
  disabled            = false
  fast_forward        = true
  forward_delay       = "15s"
  igmp_snooping       = false
  max_message_age     = "20s"
  mtu                 = "auto"
  mvrp                = false
  name                = "bridge"
  port_cost_mode      = "long"
  priority            = "0x8000"
  protocol_mode       = "rstp"
  transmit_hold_count = 6
  vlan_filtering      = true
}

resource "routeros_interface_bridge_port" "bridge_ports" {
  for_each = local.bridge_ports

  auto_isolate         = false
  bpdu_guard           = false
  bridge               = routeros_interface_bridge.bridge.name
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
  restricted_role      = false
  restricted_tcn       = false
  tag_stacking         = false
  trusted              = false
  unknown_multicast_flood = true
  unknown_unicast_flood   = true
}