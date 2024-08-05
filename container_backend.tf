locals {
  container_npk_name = "container-${local.system_version}-${local.system_architecture}.npk"
}

# Container - Install package
resource "null_resource" "download_container_npk" {
  provisioner "local-exec" {
    command = <<EOT
      ./helper/download_routeros_packages.sh ${local.system_architecture} "${local.system_version}" "container"
    EOT
  }
}

resource "null_resource" "upload_container_npk" {
  provisioner "local-exec" {
    command = "scp \"/tmp/routeros_packages/${local.container_npk_name}\" ${local.router_user}@${var.router_ip}:/${local.container_npk_name}"
  }

  depends_on = [ null_resource.download_container_npk ]
}