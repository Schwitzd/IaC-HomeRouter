# SSH keys for admin user
module "sshkey_admin" {
  source = "git::https://github.com/Schwitzd/terraform-modules.git//ssh-keygen"

  algorithm     = "ED25519"
  keys_name     = local.dns_records[0].hostname
  write_to_file = true
}

resource "routeros_file" "ssh_publickey_admin" {
  name     = basename(module.sshkey_admin.public_key_filename)
  contents = module.sshkey_admin.public_key
}

resource "null_resource" "import_publickey_admin" {
  provisioner "local-exec" {
    command = <<EOT
        ssh ${local.router_user}@${var.router_ip} '/user/ssh-keys import user=${local.router_user} public-key-file=${routeros_file.ssh_publickey_admin.name} key-owner=${local.router_user}'
      EOT
  }

  depends_on = [routeros_file.ssh_publickey_admin]
}

# SSH for lego user
module "sshkey_lego" {
  source = "git::https://github.com/Schwitzd/terraform-modules.git//ssh-keygen"

  algorithm     = "ED25519"
  keys_name     = "container_lego"
  write_to_file = false
}

resource "routeros_file" "ssh_publickey_lego" {
  name     = "container_lego.pub"
  contents = module.sshkey_lego.public_key
}

resource "routeros_file" "ssh_privatekey_lego" {
  name     = "${local.containers_path}/lego/ssh/id_ed25519"
  contents = module.sshkey_lego.private_key
}

resource "null_resource" "import_publickey_lego" {
  provisioner "local-exec" {
    command = <<EOT
        ssh ${local.router_user}@${var.router_ip} '/user/ssh-keys import user=${local.lego_user} public-key-file=${routeros_file.ssh_publickey_lego.name} key-owner=${local.lego_user}'
      EOT
  }

  depends_on = [routeros_file.ssh_publickey_lego, routeros_system_user.lego]
}