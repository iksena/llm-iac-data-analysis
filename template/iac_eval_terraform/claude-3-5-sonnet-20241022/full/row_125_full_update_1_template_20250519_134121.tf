I'll help you create a Terraform configuration to fetch the latest Amazon Linux 2 AMI using the AWS AMI data source. This configuration will:

1. Set up the AWS provider
2. Use a data source to filter and fetch the latest Amazon Linux 2 AMI
3. Output the AMI ID for reference

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Data source to fetch latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Output the AMI ID
output "amazon_linux_2_ami_id" {
  description = "ID of the latest Amazon Linux 2 AMI"
  value       = data.aws_ami.amazon_linux_2.id
}

# Output the AMI Name
output "amazon_linux_2_ami_name" {
  description = "Name of the latest Amazon Linux 2 AMI"
  value       = data.aws_ami.amazon_linux_2.name
}
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider in the us-east-1 region
2. Creates a data source that searches for Amazon Linux 2 AMIs with the following criteria:
   - Most recent version
   - Owned by Amazon
   - HVM virtualization
   - EBS-backed
   - Available state
   - x86_64 architecture
3. Outputs both the AMI ID and AMI name for reference

When you apply this configuration, it will fetch the latest Amazon Linux 2 AMI information but won't create any resources (as it's just a data source). You can use the AMI ID output in other resources like EC2 instances.

The filters ensure you get:
- The most recent version of the AMI
- Only official Amazon-owned AMIs
- HVM virtualization type (recommended for most instance types)
- EBS-backed instances
- Only AMIs that are currently available
- 64-bit x86 architecture

You can use this AMI ID reference in other resources using: `data.aws_ami.amazon_linux_2.id`