# Firewall Rules - Locals
locals {
  # Firewall addresses list
  fw_addr_lists = yamldecode(file("${path.module}/_fw_addr_lists.yaml"))["fw_addr_lists"]

  # Firewall addresses list
  fw_rules = yamldecode(file("${path.module}/_fw_roles.yaml"))["fw_roles"]
}
## Firewall - NAT
resource "routeros_ip_firewall_nat" "role1" {
  action             = "masquerade"
  chain              = "srcnat"
  comment            = "defconf: masquerade"
  ipsec_policy       = "out,none"
  out_interface_list = "WAN"
}

## Firewall - Address Lists
resource "routeros_ip_firewall_addr_list" "address_lists" {
  for_each = { for record in local.fw_addr_lists : record.list => record }

  address = each.value.address
  list    = each.value.list
}

## Firewall - Rules
resource "routeros_ip_firewall_filter" "firewall_rules" {
  for_each = { for idx, rule in local.fw_rules : idx => rule }

  disabled             = lookup(each.value, "disabled", null)
  action               = each.value.action
  chain                = each.value.chain
  comment              = each.value.comment
  protocol             = lookup(each.value, "protocol", null)
  connection_state     = lookup(each.value, "connection_state", null)
  connection_nat_state = lookup(each.value, "connection_nat_state", null)
  dst_address          = lookup(each.value, "dst_address", null)
  src_address_list     = lookup(each.value, "src_address_list", null)
  dst_address_list     = lookup(each.value, "dst_address_list", null)
  dst_port             = lookup(each.value, "dst_port", null)
  in_interface         = lookup(each.value, "in_interface", null)
  out_interface        = lookup(each.value, "out_interface", null)
  in_interface_list    = lookup(each.value, "in_interface_list", null)
  out_interface_list   = lookup(each.value, "out_interface_list", null)
  ipsec_policy         = lookup(each.value, "ipsec_policy", null)
  hw_offload           = lookup(each.value, "hw_offload", null)
}
