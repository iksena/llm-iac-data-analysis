# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket  = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terraform-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/local-variables/terraform.tfstate"
    region  = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  full_project_name = "${var.project} in ${var.env}"
  location          = "Country: ${var.country} City: ${var.city}"
  az_list           = join(", ", data.aws_availability_zones.available.names)
  region            = data.aws_region.current.name
  region_az         = "In ${local.region} region are az: ${local.az_list}"
}

# ── variables.tf ────────────────────────────────────
variable "region" {
  description = "Default region"
  type        = string
  default     = "eu-central-1"  
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "local-variables example"  
}

variable "env" {
  description = "Environment"
  type        = string
  default     = "Development"  
}

variable "city" {
  description = "City Location"
  type        = string
  default     = "New York"  
}

variable "country" {
  description = "Country location"
  type        = string
  default     = "United States"  
}


# ── outputs.tf ────────────────────────────────────


# ── datasource.tf ────────────────────────────────────
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

# ── eip.tf ────────────────────────────────────
resource "aws_eip" "elastic_ip" {
    tags = {
        Name        = "Example Elasic IP"
        Owner       = "Valerii Vasianovych"
        Project     = "Project name is: ${local.full_project_name} environment"
        Location    = "Our headquaters in: ${local.location}"
        AvailableAZ = "All available AZ: ${local.az_list}"
        AZinRegion  = "${local.region_az}"
    }
} 