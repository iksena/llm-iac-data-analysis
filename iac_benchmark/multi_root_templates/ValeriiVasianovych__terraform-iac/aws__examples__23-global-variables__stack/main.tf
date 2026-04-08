terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/tfstates/examples/23-global-variables/stack/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = local.region
}

#================================================================
#================================================================

locals {
  region                 = data.terraform_remote_state.global_vars.outputs.region
  env                    = data.terraform_remote_state.global_vars.outputs.env
  common_tags            = data.terraform_remote_state.global_vars.outputs.common_tags
  security_group_ingress = data.terraform_remote_state.global_vars.outputs.security_group_ingress
  instance_types         = data.terraform_remote_state.global_vars.outputs.instance_types
}

output "region" {
  value = local.region
}

output "env" {
  value = local.env
}

output "common_tags" {
  value = local.common_tags
}

output "security_group_ingress" {
  value = local.security_group_ingress
}

output "instance_types" {
  value = local.instance_types
}

#================================================================
#================================================================