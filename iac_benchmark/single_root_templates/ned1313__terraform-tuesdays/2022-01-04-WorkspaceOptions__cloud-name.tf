# ── main.tf ────────────────────────────────────
output "workspace" {
  value = terraform.workspace
}

# ── backend.tf ────────────────────────────────────
terraform {
    cloud {
        organization = "taconet"
        workspaces {
            name = "shared-services-prod"
        }
    }
}