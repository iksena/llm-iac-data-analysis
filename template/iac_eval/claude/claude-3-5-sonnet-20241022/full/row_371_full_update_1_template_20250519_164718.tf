I'll help you create a Terraform configuration to create an AWS Lightsail Disk resource. This configuration will:

1. Set up the AWS provider
2. Create a Lightsail Disk with specified size and availability zone
3. Include necessary variables with default values

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "availability_zone" {
  description = "The availability zone where the disk will be created"
  type        = string
  default     = "us-east-1a"
}

variable "disk_name" {
  description = "Name of the Lightsail disk"
  type        = string
  default     = "my-lightsail-disk"
}

variable "disk_size_gb" {
  description = "Size of the disk in GB"
  type        = number
  default     = 8
}

# Create Lightsail Disk
resource "aws_lightsail_disk" "example_disk" {
  name              = var.disk_name
  availability_zone = var.availability_zone
  size_in_gb       = var.disk_size_gb
  
  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# Output the disk ARN
output "disk_arn" {
  description = "The ARN of the Lightsail disk"
  value       = aws_lightsail_disk.example_disk.arn
}
</iac_template>

This Terraform configuration creates an AWS Lightsail Disk with the following features:

1. Uses the AWS provider configured for the us-east-1 region
2. Creates variables for customization with sensible defaults:
   - availability_zone: defaults to us-east-1a
   - disk_name: defaults to "my-lightsail-disk"
   - disk_size_gb: defaults to 8 GB
3. Creates a Lightsail disk with the specified parameters
4. Adds tags for better resource management
5. Outputs the ARN of the created disk

You can deploy this configuration as-is using the default values, or customize it by providing different values for the variables. The disk can later be attached to a Lightsail instance as needed.

To use this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

The disk will be created in the specified availability zone with the defined size and name.