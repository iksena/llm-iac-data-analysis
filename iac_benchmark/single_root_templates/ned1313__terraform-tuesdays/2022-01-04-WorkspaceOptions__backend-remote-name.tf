# ── main.tf ────────────────────────────────────
output "workspace" {
  value = terraform.workspace
}

# ── backend.tf ────────────────────────────────────
terraform {
    backend "remote" {
        hostname = "app.terraform.io"
        organization = "taconet"
        workspaces {
            name = "networking-useast1-dev"
        }
    }
}