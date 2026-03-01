I'll help you create a Terraform configuration to deploy a basic Amazon Lightsail instance. This configuration will:

1. Set up an AWS provider
2. Create a Lightsail instance with:
   - Ubuntu 20.04 LTS as the operating system
   - A small instance plan (1 GB RAM, 1 vCPU)
   - Basic networking configuration
   - Default key pair for SSH access

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a new Lightsail Instance
resource "aws_lightsail_instance" "example_instance" {
  name              = "example-lightsail-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "ubuntu_20_04"
  bundle_id         = "nano_2_0"  # 1 GB RAM, 1 vCPU

  tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get upgrade -y
              EOF
}

# Create a static IP for the Lightsail instance
resource "aws_lightsail_static_ip" "example_static_ip" {
  name = "example-static-ip"
}

# Attach static IP to the instance
resource "aws_lightsail_static_ip_attachment" "example_static_ip_attachment" {
  static_ip_name = aws_lightsail_static_ip.example_static_ip.name
  instance_name  = aws_lightsail_instance.example_instance.name
}

# Output the public IP address
output "instance_public_ip" {
  value = aws_lightsail_static_ip.example_static_ip.ip_address
}

# Output the instance username
output "instance_username" {
  value = "ubuntu"
}
</iac_template>

This Terraform configuration creates:
1. An AWS Lightsail instance running Ubuntu 20.04 LTS
2. A static IP address
3. Attaches the static IP to the instance
4. Outputs the public IP address and default username

The instance is created with:
- The "nano" bundle (1 GB RAM, 1 vCPU)
- Basic user data script to update the system
- Tags for better resource management
- A static IP for consistent access

To use this configuration:
1. Make sure you have AWS credentials configured
2. Initialize Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

You can access the instance using SSH with the default username "ubuntu" and the default key pair configured in your AWS account.