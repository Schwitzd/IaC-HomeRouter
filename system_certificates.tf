# Certificates
data "routeros_x509" "certs" {
  for_each = {
    quad9_root = "${path.module}/certs/digicert_global_root_g3.pem"
    amazon_m01 = "${path.module}/certs/amazon_rsa_2048_m01.pem"
  }
  data = file(each.value)
}

# Certificates - Metadata
locals {
  ca_certs = {
    quad9_root = {
      filename    = "digicert-global-root-g3.pem"
      friendly    = "digicert-global-root-g3"
      pem         = data.routeros_x509.certs["quad9_root"].pem
      common_name = data.routeros_x509.certs["quad9_root"].common_name
    }
    amazon_m01 = {
      filename    = "amazon-rsa-2048-m01.pem"
      friendly    = "amazon-rsa-2048-m01"
      pem         = data.routeros_x509.certs["amazon_m01"].pem
      common_name = data.routeros_x509.certs["amazon_m01"].common_name
    }
  }
}

# Certificates - Upload
resource "routeros_file" "ca" {
  for_each = local.ca_certs

  name     = each.value.filename
  contents = each.value.pem
}

# Certificates - Import
resource "routeros_system_certificate" "ca" {
  for_each = local.ca_certs

  name        = each.value.friendly
  common_name = each.value.common_name

  import {
    cert_file_name = routeros_file.ca[each.key].name
  }

  lifecycle {
    create_before_destroy = true
    replace_triggered_by  = [routeros_file.ca[each.key].id]
  }

  depends_on = [
    routeros_file.ca
  ]
}