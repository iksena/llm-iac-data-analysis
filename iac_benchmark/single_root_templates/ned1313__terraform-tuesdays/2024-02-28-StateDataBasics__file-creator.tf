# ── main.tf ────────────────────────────────────
resource "local_file" "my_file" {
  content  = var.content
  filename = "${path.root}/${var.filename}"
}

# ── variables.tf ────────────────────────────────────
variable "content" {}

variable "filename" {}

# ── outputs.tf ────────────────────────────────────
# No outputs defined
output "stuff" {
  value = local_file.my_file.id
}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~>2.0"
    }
  }
}

