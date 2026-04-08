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