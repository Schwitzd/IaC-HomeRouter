locals {
  container_npk_name = "container-${local.system_version}-${local.system_architecture}.npk"
}

# Container - Install package
resource "null_resource" "download_container_npk" {
  provisioner "local-exec" {
    command = <<EOT
      chmod +x ./helper/download_routeros_packages.sh
      ./helper/download_routeros_packages.sh ${local.system_architecture} "${local.system_version}" "container"
    EOT
  }
}

resource "null_resource" "upload_container_npk" {
  provisioner "local-exec" {
    command = "scp -i ${local.router_ssh_key} \"/tmp/routeros_packages/${local.container_npk_name}\" ${local.router_user}@${var.router_ip}:/${local.container_npk_name}"
  }

  depends_on = [ null_resource.download_container_npk ]
}

resource "null_resource" "install_container_npk" {
  provisioner "local-exec" {
      command = <<EOT
        ssh -i ${local.router_ssh_key} ${local.router_user}@${var.router_ip} '/system reboot'; sleep 3
        until ssh -i ${local.router_ssh_key} -o ConnectTimeout=2 ${local.router_user}@${var.router_ip} ':put True' 2> /dev/null
        do
          echo "Waiting for router to reboot and become available..."
          sleep 10
        done
      EOT
  }

  depends_on = [ null_resource.upload_container_npk ]
}