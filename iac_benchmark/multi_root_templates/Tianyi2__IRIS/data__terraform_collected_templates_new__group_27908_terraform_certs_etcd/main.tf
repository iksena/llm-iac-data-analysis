variable "ca_cert_pem" {}
variable "ca_private_key_pem" {}

resource "tls_private_key" "etcd" {
  algorithm = "RSA"
}

resource "tls_cert_request" "etcd" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.etcd.private_key_pem}"

  subject {
    common_name  = "*"
    organization = "etcd"
  }
}

resource "tls_locally_signed_cert" "etcd" {
  cert_request_pem   = "${tls_cert_request.etcd.cert_request_pem}"
  ca_key_algorithm   = "RSA"
  ca_private_key_pem = "${var.ca_private_key_pem}"
  ca_cert_pem        = "${var.ca_cert_pem}"

  # valid for 365 days
  validity_period_hours = 8760
  early_renewal_hours   = 720

  allowed_uses = [
    "key_encipherment",
    "server_auth",
    "client_auth"
  ]
}

output "etcd_cert_pem" {
  value = "${tls_locally_signed_cert.etcd.cert_pem}"
}
output "etcd_private_key" {
  value = "${tls_private_key.etcd.private_key_pem}"
}
