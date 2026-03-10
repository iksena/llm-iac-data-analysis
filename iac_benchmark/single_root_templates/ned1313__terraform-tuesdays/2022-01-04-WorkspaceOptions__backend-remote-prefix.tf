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
            prefix = "application-"
        }
    }
    /*cloud {
        organization = "taconet"

        workspaces {
            tags = ["app:taco"]
        }
    }*/
}