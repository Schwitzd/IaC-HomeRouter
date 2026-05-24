# Locals - vETH
locals {
  veth_interfaces = {
    lego = {
      name    = "veth-lego"
      comment = "Virtual interface for lego container"
    }
    cloudflared = {
      name    = "veth-cloudflared"
      comment = "Virtual interface for cloudflared container"
    }
  }
}

# vETH - lego
resource "routeros_interface_veth" "lego" {
  name    = local.veth_interfaces.lego.name
  address = ["192.168.101.2/${local.networks_static.mycontainer.mask}"]
  gateway = local.networks_static.mycontainer.gateway
  comment = local.veth_interfaces.lego.comment
}

# vETH - cloudflared
resource "routeros_interface_veth" "cloudflared" {
  name    = local.veth_interfaces.cloudflared.name
  address = ["192.168.101.3/${local.networks_static.mycontainer.mask}"]
  gateway = local.networks_static.mycontainer.gateway
  comment = local.veth_interfaces.cloudflared.comment
}
