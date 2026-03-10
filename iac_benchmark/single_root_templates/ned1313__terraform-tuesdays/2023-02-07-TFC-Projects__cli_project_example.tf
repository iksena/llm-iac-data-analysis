# ── main.tf ────────────────────────────────────
resource "random_string" "main" {
  length  = 8
  special = false
  upper   = false
}

output "name" {
  value = random_string.main.result
}

# ── terraform.tf ────────────────────────────────────
terraform {
  /*backend "remote" {
    organization = "nitc-project-demo"

    workspaces {
      name = "project_example_remote_backend"
    }
  }*/
  
  cloud {
    organization = "nitc-project-demo"

    workspaces {
      name = "project_example_remote_backend"
    }
  }
}