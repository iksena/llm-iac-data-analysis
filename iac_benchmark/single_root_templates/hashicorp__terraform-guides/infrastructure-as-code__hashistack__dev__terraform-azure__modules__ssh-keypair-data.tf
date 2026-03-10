# ── main.tf ────────────────────────────────────
resource "tls_private_key" "main" {
  algorithm = "RSA"
}

resource "null_resource" "main" {
  provisioner "local-exec" {
    command = "echo \"${tls_private_key.main.private_key_pem}\" > ${var.private_key_filename}"
  }

  provisioner "local-exec" {
    command = "chmod 600 ${var.private_key_filename}"
  }
}


# ── _interface.tf ────────────────────────────────────
# Optional Variables
variable "private_key_filename" {
  default     = "private_key.pem"
  description = "Filename to write the private key data to eg key.pem"
}

# Outputs
output "private_key_pem" {
  value = "${tls_private_key.main.private_key_pem}"
}

output "public_key_data" {
  value = "${tls_private_key.main.public_key_openssh}"
}
