resource "routeros_ipv6_settings" "settings" {
    accept_redirects               = "yes-if-forwarding-disabled"
    accept_router_advertisements   = "yes-if-forwarding-disabled"
    allow_fast_path                = true
    disable_ipv6                   = false
    disable_link_local_address     = false
    forward                        = true
    max_neighbor_entries           = 14336
    min_neighbor_entries           = 3584
    multipath_hash_policy          = "l3"
    soft_max_neighbor_entries      = 7168
    stale_neighbor_detect_interval = "30"
    stale_neighbor_timeout         = "60"
}