# ── main.tf ────────────────────────────────────
output "workspace" {
  value = terraform.workspace
}

# ── backend.tf ────────────────────────────────────
terraform {
    cloud {
        organization = "taconet"
        workspaces {
            tags = ["security","cloud:aws"]
        }
    }
}