# DNS - Server
resource "routeros_dns" "dns-server" {
  allow_remote_requests       = true
  cache_max_ttl               = "1w"
  cache_size                  = 2048
  doh_max_concurrent_queries  = 50
  doh_max_server_connections  = 5
  doh_timeout                 = "5s"
  max_concurrent_queries      = 100
  max_concurrent_tcp_sessions = 20
  max_udp_packet_size         = 4096
  query_server_timeout        = "2s"
  query_total_timeout         = "10s"
  servers = [
    "9.9.9.9",
    "149.112.112.112",
  ]
  use_doh_server  = "https://dns.quad9.net/dns-query"
  verify_doh_cert = true

  depends_on = [routeros_system_certificate.quad9_root]
}

# DNS - Static
resource "routeros_ip_dns_record" "dns_records" {
  for_each = { for record in local.static_hosts : record.hostname => record }

  name    = each.value.hostname
  address = lookup(each.value, "ip", null)
  cname   = lookup(each.value, "cname", null)
  type    = each.value.type

}
