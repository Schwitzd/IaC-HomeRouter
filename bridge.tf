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

## Bridge - Ports
resource "routeros_interface_bridge_port" "ether1" {
  auto_isolate         = false
  bpdu_guard           = false
  bridge               = "bridge"
  broadcast_flood      = true
  comment              = "defconf"
  disabled             = false
  edge                 = "auto"
  fast_leave           = false
  frame_types          = "admit-all"
  horizon              = "none"
  hw                   = true
  ingress_filtering    = true
  interface            = "ether1"
  learn                = "auto"
  multicast_router     = "temporary-query"
  mvrp_applicant_state = "normal-participant"
  mvrp_registrar_state = "normal"
  point_to_point       = "auto"
  #  priority                = "x80"
  pvid                    = 1
  restricted_role         = false
  restricted_tcn          = false
  tag_stacking            = false
  trusted                 = false
  unknown_multicast_flood = true
  unknown_unicast_flood   = true
}

resource "routeros_interface_bridge_port" "ether2" {
  auto_isolate         = false
  bpdu_guard           = false
  bridge               = "bridge"
  broadcast_flood      = true
  comment              = "defconf"
  disabled             = false
  edge                 = "auto"
  fast_leave           = false
  frame_types          = "admit-all"
  horizon              = "none"
  hw                   = true
  ingress_filtering    = true
  interface            = "ether2"
  learn                = "auto"
  multicast_router     = "temporary-query"
  mvrp_applicant_state = "normal-participant"
  mvrp_registrar_state = "normal"
  point_to_point       = "auto"
  #  priority                = "x80"
  pvid                    = 1
  restricted_role         = false
  restricted_tcn          = false
  tag_stacking            = false
  trusted                 = false
  unknown_multicast_flood = true
  unknown_unicast_flood   = true
}

resource "routeros_interface_bridge_port" "ether3" {
  auto_isolate         = false
  bpdu_guard           = false
  bridge               = "bridge"
  broadcast_flood      = true
  comment              = "defconf"
  disabled             = false
  edge                 = "auto"
  fast_leave           = false
  frame_types          = "admit-all"
  horizon              = "none"
  hw                   = true
  ingress_filtering    = true
  interface            = "ether3"
  learn                = "auto"
  multicast_router     = "temporary-query"
  mvrp_applicant_state = "normal-participant"
  mvrp_registrar_state = "normal"
  point_to_point       = "auto"
  #  priority                = "x80"
  pvid                    = 1
  restricted_role         = false
  restricted_tcn          = false
  tag_stacking            = false
  trusted                 = false
  unknown_multicast_flood = true
  unknown_unicast_flood   = true
}

resource "routeros_interface_bridge_port" "ether4" {
  auto_isolate         = false
  bpdu_guard           = false
  bridge               = "bridge"
  broadcast_flood      = true
  comment              = "defconf"
  disabled             = false
  edge                 = "auto"
  fast_leave           = false
  frame_types          = "admit-all"
  horizon              = "none"
  hw                   = true
  ingress_filtering    = true
  interface            = "ether4"
  learn                = "auto"
  multicast_router     = "temporary-query"
  mvrp_applicant_state = "normal-participant"
  mvrp_registrar_state = "normal"
  point_to_point       = "auto"
  #  priority                = "x80"
  pvid                    = 1
  restricted_role         = false
  restricted_tcn          = false
  tag_stacking            = false
  trusted                 = false
  unknown_multicast_flood = true
  unknown_unicast_flood   = true
}

resource "routeros_interface_bridge_port" "ether5" {
  auto_isolate         = false
  bpdu_guard           = false
  bridge               = "bridge"
  broadcast_flood      = true
  comment              = "defconf"
  disabled             = false
  edge                 = "auto"
  fast_leave           = false
  frame_types          = "admit-all"
  horizon              = "none"
  hw                   = true
  ingress_filtering    = true
  interface            = "ether5"
  learn                = "auto"
  multicast_router     = "temporary-query"
  mvrp_applicant_state = "normal-participant"
  mvrp_registrar_state = "normal"
  point_to_point       = "auto"
  #  priority                = "x80"
  pvid                    = 1
  restricted_role         = false
  restricted_tcn          = false
  tag_stacking            = false
  trusted                 = false
  unknown_multicast_flood = true
  unknown_unicast_flood   = true
}