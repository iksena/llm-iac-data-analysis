I'll help you create a Terraform configuration that defines a default Network ACL (NACL) in AWS with unrestricted ingress and egress rules. This configuration will:

1. Create a VPC
2. Create a Network ACL
3. Define unrestricted ingress rules (allow all inbound traffic)
4. Define unrestricted egress rules (allow all outbound traffic)
5. Associate the NACL with the VPC

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Create Network ACL
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id

  # Allow all inbound traffic
  ingress {
    protocol   = "-1" # All protocols
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Allow all outbound traffic
  egress {
    protocol   = "-1" # All protocols
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "main-open-nacl"
  }
}

# Output the Network ACL ID
output "network_acl_id" {
  value       = aws_network_acl.main.id
  description = "The ID of the Network ACL"
}

# Output the VPC ID
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-west-2 region
2. A VPC with the CIDR block 10.0.0.0/16 (configurable via variable)
3. A Network ACL with:
   - An ingress rule allowing all traffic (all protocols, ports, and sources)
   - An egress rule allowing all traffic (all protocols, ports, and destinations)
4. Output values for both the Network ACL ID and VPC ID

The configuration uses:
- Protocol "-1" which means all protocols
- Rule number 100 for both ingress and egress rules
- CIDR block 0.0.0.0/0 to allow traffic from/to any IP address
- From_port and to_port set to 0 to allow all ports

This creates a completely open Network ACL, which should be used carefully and only in specific testing scenarios or when required by the specific use case. In production environments, it's recommended to implement more restrictive rules based on security requirements.