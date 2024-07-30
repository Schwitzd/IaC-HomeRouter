# Quad9 Root CA

data "routeros_x509" "quad9_root" {
  data = <<EOT
-----BEGIN CERTIFICATE-----
MIIDeTCCAv+gAwIBAgIQDCJUGB1t/fpm4mTjwXpIvDAKBggqhkjOPQQDAzBhMQsw
CQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cu
ZGlnaWNlcnQuY29tMSAwHgYDVQQDExdEaWdpQ2VydCBHbG9iYWwgUm9vdCBHMzAe
Fw0yMTAzMzAwMDAwMDBaFw0zMTAzMjkyMzU5NTlaMFkxCzAJBgNVBAYTAlVTMRUw
EwYDVQQKEwxEaWdpQ2VydCBJbmMxMzAxBgNVBAMTKkRpZ2lDZXJ0IEdsb2JhbCBH
MyBUTFMgRUNDIFNIQTM4NCAyMDIwIENBMTB2MBAGByqGSM49AgEGBSuBBAAiA2IA
BHipnHWuiF1jpK1dhtgQSdavklljQyOF9EhlMM1KNJWmDj7ZfAjXVwUoSJ4Lq+vC
05ae7UXSi4rOAUsXQ+Fzz21zSDTcAEYJtVZUyV96xxMH0GwYF2zK28cLJlYujQf1
Z6OCAYIwggF+MBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFIoj655r1/k3
XfltITl2mqFn3hCoMB8GA1UdIwQYMBaAFLPbSKT5ocXYrjZBzBFjaWIpvEvGMA4G
A1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwdgYI
KwYBBQUHAQEEajBoMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5j
b20wQAYIKwYBBQUHMAKGNGh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdp
Q2VydEdsb2JhbFJvb3RHMy5jcnQwQgYDVR0fBDswOTA3oDWgM4YxaHR0cDovL2Ny
bDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0R2xvYmFsUm9vdEczLmNybDA9BgNVHSAE
NjA0MAsGCWCGSAGG/WwCATAHBgVngQwBATAIBgZngQwBAgEwCAYGZ4EMAQICMAgG
BmeBDAECAzAKBggqhkjOPQQDAwNoADBlAjAdIuJYQITJrIeX+XKyNUbQGHZ6YhRz
fZrAkUOo847MAe232GlXYw8cE5Vh7hOotCsCMQDgwJgM+AcC2kL4BM7eaaprMi5u
FEMbiAcHmsTBJS3vzvx7eJ9JlMhlrGSu7QrmeIg=
-----END CERTIFICATE-----
EOT
}
resource "routeros_file" "quad9_root" {
  name = "DigiCertGlobalG3TLSECCSHA3842020CA1-1.crt.pem"
  contents = data.routeros_x509.quad9_root.pem
}

resource "routeros_system_certificate" "quad9_root" {
  name        = "Quad9-root"
  common_name = data.routeros_x509.quad9_root.common_name
  import {
    cert_file_name = routeros_file.quad9_root.name
  }
  depends_on = [routeros_file.quad9_root]
}