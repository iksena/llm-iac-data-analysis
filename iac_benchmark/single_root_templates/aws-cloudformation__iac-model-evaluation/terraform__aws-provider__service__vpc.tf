# ── aws_vpc_merge_function.tf ────────────────────────────────────
# merge tags from two variables into locales called combined_tags, use function merge to merge tags from two variables called env_tags and business_tags
locals {
  combined_tags = merge(var.env_tags, var.business_tags)
}

variable "env_tags" {
  type = map(string)
  default = {
    Environment = "Sandbox"
  }
}

variable "business_tags" {
  type = map(string)
  default = {
    BusinessUnit = "Finance"
    Application  = "Example"
  }
}

# create vpc using the combined tags
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = local.combined_tags
}

# ── aws_vpc_p1.tf ────────────────────────────────────
# Create a VPC named 'example' with cidr_block '10.0.0.0/16' via the 'aws' provider

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

}


# ── aws_vpc_p2.tf ────────────────────────────────────
# Terraform code to create a VPC named 'example' with cidr_block '10.0.0.0/16' via the 'aws' provider

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

}


# ── aws_vpc_with_dedicated_instance_tenancy_p1.tf ────────────────────────────────────
# Create a VPC named 'example' with cidr_block '10.0.0.0/16' and instance_tenancy 'dedicated' via the 'aws' provider

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "dedicated"

}


# ── aws_vpc_with_dedicated_instance_tenancy_p2.tf ────────────────────────────────────
# Terraform code to create a VPC named 'example' with cidr_block '10.0.0.0/16' and instance_tenancy 'dedicated' via the 'aws' provider

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "dedicated"

}


# ── aws_vpc_with_dns_hostnames_enabled_p1.tf ────────────────────────────────────
# Create a VPC named 'example' with cidr_block '10.0.0.0/16' and dns host names enabled via the 'aws' provider

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

}


# ── aws_vpc_with_dns_hostnames_enabled_p2.tf ────────────────────────────────────
# Terraform code to create a VPC named 'example' with cidr_block '10.0.0.0/16' and dns host names enabled via the 'aws' provider

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

}
