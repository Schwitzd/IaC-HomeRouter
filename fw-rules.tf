locals {
  firewall_rules = {
    role0 = {
      action           = "accept"
      chain            = "input"
      comment          = "defconf: accept established,related,untracked"
      connection_state = "established,related,untracked"
    }
    role1 = {
      action           = "drop"
      chain            = "input"
      comment          = "defconf: drop invalid"
      connection_state = "invalid"
    }
    role2 = {
      action   = "accept"
      chain    = "input"
      comment  = "defconf: accept ICMP"
      protocol = "icmp"
    }
    role3 = {
      action      = "accept"
      chain       = "input"
      comment     = "defconf: accept to local loopback (for CAPsMAN)"
      dst_address = "127.0.0.1"
    }
    role4 = {
      action             = "drop"
      chain              = "input"
      comment            = "defconf: drop all not coming from LAN"
      in_interface_list  = "!LAN"
    }
    role5 = {
      action       = "accept"
      chain        = "forward"
      comment      = "defconf: accept in ipsec policy"
      ipsec_policy = "in,ipsec"
    }
    role6 = {
      action       = "accept"
      chain        = "forward"
      comment      = "defconf: accept out ipsec policy"
      ipsec_policy = "out,ipsec"
    }
    role7 = {
      action           = "fasttrack-connection"
      chain            = "forward"
      comment          = "defconf: fasttrack"
      connection_state = "established,related"
      hw_offload       = true
    }
    role8 = {
      action           = "accept"
      chain            = "forward"
      comment          = "defconf: accept established,related,untracked"
      connection_state = "established,related,untracked"
    }
    role9 = {
      action           = "drop"
      chain            = "forward"
      comment          = "defconf: drop invalid"
      connection_state = "invalid"
    }
    role10 = {
      action               = "drop"
      chain                = "forward"
      comment              = "defconf: drop all from WAN not DSTNATed"
      connection_nat_state = "!dstnat"
      connection_state     = "new"
      in_interface_list    = "WAN"
    }
  }
}

## Firewall NAT
resource "routeros_ip_firewall_nat" "role1" {
  action                    = "masquerade"
  chain                     = "srcnat"
  comment                   = "defconf: masquerade"
  ipsec_policy              = "out,none"
  out_interface_list        = "WAN"
}

## Firewall Rules
resource "routeros_ip_firewall_filter" "firewall_rules" {
  for_each = local.firewall_rules

  action               = each.value.action
  chain                = each.value.chain
  comment              = each.value.comment
  connection_state     = lookup(each.value, "connection_state", null)
  protocol             = lookup(each.value, "protocol", null)
  dst_address          = lookup(each.value, "dst_address", null)
  in_interface_list    = lookup(each.value, "in_interface_list", null)
  ipsec_policy         = lookup(each.value, "ipsec_policy", null)
  hw_offload           = lookup(each.value, "hw_offload", null)
  connection_nat_state = lookup(each.value, "connection_nat_state", null)
}

/*
resource "routeros_ip_firewall_filter" "role0" {
  action           = "accept"
  chain            = "input"
  comment          = "defconf: accept established,related,untracked"
  connection_state = "established,related,untracked"
}

resource "routeros_ip_firewall_filter" "role1" {
  action           = "drop"
  chain            = "input"
  comment          = "defconf: drop invalid"
  connection_state = "invalid"
}

resource "routeros_ip_firewall_filter" "role2" {
  action   = "accept"
  chain    = "input"
  comment  = "defconf: accept ICMP"
  protocol = "icmp"
}

resource "routeros_ip_firewall_filter" "role3" {
  action      = "accept"
  chain       = "input"
  comment     = "defconf: accept to local loopback (for CAPsMAN)"
  dst_address = "127.0.0.1"
}

resource "routeros_ip_firewall_filter" "role4" {
  action            = "drop"
  chain             = "input"
  comment           = "defconf: drop all not coming from LAN"
  in_interface_list = "!LAN"
}

resource "routeros_ip_firewall_filter" "role5" {
  action       = "accept"
  chain        = "forward"
  comment      = "defconf: accept in ipsec policy"
  ipsec_policy = "in,ipsec"
}

resource "routeros_ip_firewall_filter" "role6" {
  action       = "accept"
  chain        = "forward"
  comment      = "defconf: accept out ipsec policy"
  ipsec_policy = "out,ipsec"
}

resource "routeros_ip_firewall_filter" "role7" {
  action           = "fasttrack-connection"
  chain            = "forward"
  comment          = "defconf: fasttrack"
  connection_state = "established,related"
  hw_offload       = true
}

resource "routeros_ip_firewall_filter" "role8" {
  action           = "accept"
  chain            = "forward"
  comment          = "defconf: accept established,related, untracked"
  connection_state = "established,related,untracked"
}

resource "routeros_ip_firewall_filter" "role9" {
  action           = "drop"
  chain            = "forward"
  comment          = "defconf: drop invalid"
  connection_state = "invalid"
}

resource "routeros_ip_firewall_filter" "role10" {
  action               = "drop"
  chain                = "forward"
  comment              = "defconf: drop all from WAN not DSTNATed"
  connection_nat_state = "!dstnat"
  connection_state     = "new"
  in_interface_list    = "WAN"
}
*/