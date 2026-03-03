I'll help you create a Terraform configuration for AWS Lightsail instance with automatic snapshots enabled. This configuration will:

1. Create an AWS Lightsail instance
2. Enable automatic snapshots for the instance
3. Set up proper provider configuration
4. Configure instance with basic settings

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create Lightsail Instance
resource "aws_lightsail_instance" "example_instance" {
  name              = "example-lightsail-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"  # Smallest instance size

  tags = {
    Environment = "Production"
    Name        = "Example Instance"
  }
}

# Enable automatic snapshots for the Lightsail instance
resource "aws_lightsail_instance_automatic_snapshot" "example_auto_snapshot" {
  instance_name = aws_lightsail_instance.example_instance.name
  time_of_day  = "06:00"  # UTC time when snapshot should be taken
}

# Optional: Create a static IP for the instance
resource "aws_lightsail_static_ip" "example_static_ip" {
  name = "example-static-ip"
}

# Attach static IP to the instance
resource "aws_lightsail_static_ip_attachment" "example_static_ip_attachment" {
  static_ip_name = aws_lightsail_static_ip.example_static_ip.name
  instance_name  = aws_lightsail_instance.example_instance.name
}

# Output the instance public IP address
output "instance_public_ip" {
  value = aws_lightsail_static_ip.example_static_ip.ip_address
}

# Output the instance ARN
output "instance_arn" {
  value = aws_lightsail_instance.example_instance.arn
}
</iac_template>

This Terraform configuration creates:
1. An AWS Lightsail instance running Amazon Linux 2
2. Automatic daily snapshots at 06:00 UTC
3. A static IP address attached to the instance
4. Outputs for the public IP address and instance ARN

The instance is configured with:
- Nano bundle (smallest size, 1 vCPU, 512 MB RAM)
- Amazon Linux 2 as the operating system
- Located in us-east-1a availability zone
- Proper tagging for environment and name
- Automatic snapshots enabled

To deploy this configuration:
1. Make sure you have AWS credentials configured
2. Initialize Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

The automatic snapshots will be taken daily at 06:00 UTC, and the instance will be accessible via the static IP address that's created and attached to it.