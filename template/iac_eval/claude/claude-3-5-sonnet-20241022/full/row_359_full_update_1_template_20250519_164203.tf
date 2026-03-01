I'll help you create a Terraform configuration to deploy an Amazon Lightsail instance with user data. This configuration will:

1. Set up an AWS provider
2. Create a Lightsail instance with:
   - A basic Ubuntu 20.04 LTS instance
   - User data script to update packages and install nginx
   - Standard Lightsail instance size (1 GB RAM, 1 vCPU)
   - Open ports for HTTP and SSH access

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
  blueprint_id      = "ubuntu_20_04"
  bundle_id         = "nano_2_0"  # 1 GB RAM, 1 vCPU

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Environment = "Development"
  }
}

# Open ports for the instance
resource "aws_lightsail_instance_public_ports" "example_ports" {
  instance_name = aws_lightsail_instance.example_instance.name

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
  }
}

# Output the public IP address
output "public_ip" {
  value = aws_lightsail_instance.example_instance.public_ip_address
}

# Output the instance URL
output "instance_url" {
  value = "http://${aws_lightsail_instance.example_instance.public_ip_address}"
}
</iac_template>

This Terraform configuration will:
1. Create a Lightsail instance running Ubuntu 20.04 LTS
2. Execute user data script that installs and starts nginx
3. Configure firewall rules to allow HTTP (port 80) and SSH (port 22) access
4. Output the instance's public IP address and URL

The instance will be created in the us-east-1 region, specifically in the us-east-1a availability zone. The instance type (bundle_id) is set to "nano_2_0" which provides 1 GB RAM and 1 vCPU, suitable for basic web hosting needs.

To deploy this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

After deployment, you can access the nginx welcome page by visiting the URL provided in the outputs.