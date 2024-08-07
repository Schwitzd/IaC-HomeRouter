# Generate SSH keys for admin user
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
        ssh ${local.router_user}@${var.router_ip} '/user/ssh-keys import user=${local.router_user}  public-key-file=${routeros_file.ssh_publickey_admin.name} key-owner=${local.router_user}'
      EOT
  }

  depends_on = [ routeros_file.ssh_publickey_admin ]
}