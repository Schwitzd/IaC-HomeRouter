# Firewall Rules - Locals
locals {
  # Firewall addresses list
  fw_rules_v6 = yamldecode(file("${path.module}/_fw_roles_v6.yaml"))["fw_roles"]
}

## Firewall - Rules
resource "routeros_ipv6_firewall_filter" "firewall_rules" {
  for_each = { for idx, rule in local.fw_rules_v6 : idx => rule }

  disabled             = lookup(each.value, "disabled", null)
  action               = each.value.action
  chain                = each.value.chain
  comment              = each.value.comment
  protocol             = lookup(each.value, "protocol", null)
  connection_state     = lookup(each.value, "connection_state", null)
  dst_address          = lookup(each.value, "dst_address", null)
  src_address_list     = lookup(each.value, "src_address_list", null)
  dst_address_list     = lookup(each.value, "dst_address_list", null)
  dst_port             = lookup(each.value, "dst_port", null)
  in_interface         = lookup(each.value, "in_interface", null)
  out_interface        = lookup(each.value, "out_interface", null)
  in_interface_list    = lookup(each.value, "in_interface_list", null)
  out_interface_list   = lookup(each.value, "out_interface_list", null)
  ipsec_policy         = lookup(each.value, "ipsec_policy", null)
}
