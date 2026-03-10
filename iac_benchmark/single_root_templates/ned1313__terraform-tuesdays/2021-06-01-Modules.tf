# ── variables.tf ────────────────────────────────────
variable "meat" {
  type = string
  default = "chicken"
}

variable "cheese" {
  type = string
  default = "jack"
}

variable "shell" {
  type = string
  default = "corn"
}

# ── outputs.tf ────────────────────────────────────


output "taco_info" {
  value = local.taco
}



# ── locals.tf ────────────────────────────────────
locals {
  taco = {
      meat = var.meat
      cheese = var.cheese
      shell = var.shell
  }
}



# ── resources.tf ────────────────────────────────────


resource "local_file" "taco_order" {
  content = jsonencode(local.taco)
  filename = "${path.module}/order.json"
}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_providers {
      # List of providers
  }
}