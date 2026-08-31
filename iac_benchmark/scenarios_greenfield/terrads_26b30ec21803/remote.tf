data "terraform_remote_state" "terraform-hcp-core" {
  backend = "remote"

  config = {
    organization = var.tfc_organization
    workspaces = {
      name = "hcp-core"
    }
  }
}

data "terraform_remote_state" "aws-core" {
  backend = "remote"

  config = {
    organization = var.tfc_organization
    workspaces = {
      name = "aws-core"
    }
  }
}