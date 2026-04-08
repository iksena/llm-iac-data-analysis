# Remote state reference to shared environment
# This is the enterprise pattern for cross-environment dependencies
data "terraform_remote_state" "shared" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "your-storage-account-name"
    container_name       = "tfstate"
    key                  = "shared.terraform.tfstate"
  }
}

# Local values for easier access to shared resources
locals {
  shared_acr_name              = try(data.terraform_remote_state.shared.outputs.acr_name, "placeholder-acr")
  shared_acr_login_server      = try(data.terraform_remote_state.shared.outputs.acr_login_server, "placeholder.azurecr.io")
  shared_acr_id                = try(data.terraform_remote_state.shared.outputs.acr_id, "placeholder-id")
  shared_resource_group_name   = try(data.terraform_remote_state.shared.outputs.resource_group_name, "placeholder-rg")
  
  # GitHub Actions service principal info (if needed)
  github_actions_client_id     = try(data.terraform_remote_state.shared.outputs.github_actions_client_id, "placeholder-client-id")
  github_actions_object_id     = try(data.terraform_remote_state.shared.outputs.github_actions_object_id, "placeholder-object-id")
}
