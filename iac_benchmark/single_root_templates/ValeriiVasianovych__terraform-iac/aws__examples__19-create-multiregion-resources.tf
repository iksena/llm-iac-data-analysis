# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terraform-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/multiregion/terraform.tfstate"
    region  = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

# ── variables.tf ────────────────────────────────────
variable "region_name" {
  default = ["us-east-1", "eu-north-1", "eu-central-1"]
}

# ── outputs.tf ────────────────────────────────────
output "aws_caller_identity" {
    value = data.aws_caller_identity.current.id
}

output "show_created_vpc" {
    value = [
        aws_vpc.vpc-1.id,
        aws_vpc.vpc-2.id,
        aws_vpc.vpc-3.id
    ]
}

# ── datasource.tf ────────────────────────────────────
data "aws_caller_identity" "current" {}

# ── provider.tf ────────────────────────────────────
provider "aws" {
  region = var.region_name[0]
  alias  = "region-1"

  assume_role {
    # Region-level control:
    # Example has three providers to operate in different regions. 
    # If you want to: 
    # - Manage resources in regions with different access levels or configurations, 
    # - Use specific roles for each region,
    
    # Example scenario:
    # The role for region-1 allows managing only EC2 and RDS.
    # For region-2, there is no role, direct access is used.
    # For region-3, the role allows managing only S3.

    # Session name is a unique identifier for the assumed role session.
    role_arn = "arn:aws:iam::123456789012:role/terraform" # Now this role will use for specific region and you can specify specific permissions for this role and use it only in this region
    session_name = "terraform"
  }
}

provider "aws" {
  region = var.region_name[1]
  alias  = "region-2"
}

provider "aws" {
  region = var.region_name[2]
  alias  = "region-3"
}

# ── vpc.tf ────────────────────────────────────
resource "aws_vpc" "vpc-1" {
  provider   = aws.region-1
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC-${var.region_name[0]}"
  }
}

resource "aws_vpc" "vpc-2" {
  provider   = aws.region-2
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "VPC-${var.region_name[1]}"
  }
}

resource "aws_vpc" "vpc-3" {
  provider   = aws.region-3
  cidr_block = "172.16.0.0/16"
  tags = {
    Name = "VPC-${var.region_name[2]}"
  }
}