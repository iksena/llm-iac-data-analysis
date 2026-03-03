I'll help you create a Terraform configuration to deploy an Amazon Lightsail instance with a dedicated SSH key pair. This configuration will:

1. Create a new Lightsail key pair for SSH access
2. Create a Lightsail instance using Ubuntu 20.04 LTS
3. Configure basic networking and firewall rules
4. Output the public IP address and SSH connection details

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create Lightsail Key Pair
resource "aws_lightsail_key_pair" "my_key_pair" {
  name = "lightsail-key-pair"
}

# Create Lightsail Instance
resource "aws_lightsail_instance" "my_instance" {
  name              = "my-lightsail-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "ubuntu_20_04"
  bundle_id         = "nano_2_0"
  key_pair_name     = aws_lightsail_key_pair.my_key_pair.name

  tags = {
    Environment = "Development"
  }
}

# Create Lightsail Static IP
resource "aws_lightsail_static_ip" "my_static_ip" {
  name = "my-static-ip"
}

# Attach Static IP to Instance
resource "aws_lightsail_static_ip_attachment" "my_static_ip_attachment" {
  static_ip_name = aws_lightsail_static_ip.my_static_ip.name
  instance_name  = aws_lightsail_instance.my_instance.name
}

# Open required ports
resource "aws_lightsail_instance_public_ports" "my_instance_ports" {
  instance_name = aws_lightsail_instance.my_instance.name

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

  port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
  }
}

# Output values
output "instance_ip" {
  value = aws_lightsail_static_ip.my_static_ip.ip_address
  description = "Public IP address of the Lightsail instance"
}

output "ssh_connection_string" {
  value = "ssh -i ${aws_lightsail_key_pair.my_key_pair.name}.pem ubuntu@${aws_lightsail_static_ip.my_static_ip.ip_address}"
  description = "SSH connection string for the instance"
}

output "private_key_path" {
  value = aws_lightsail_key_pair.my_key_pair.private_key_pem
  description = "Private key for SSH access"
  sensitive = true
}
</iac_template>

This Terraform configuration creates:
1. An AWS Lightsail key pair for secure SSH access
2. A Lightsail instance running Ubuntu 20.04 LTS on the nano_2_0 bundle (1 vCPU, 512MB RAM)
3. A static IP address attached to the instance
4. Security group rules allowing SSH (22), HTTP (80), and HTTPS (443) access
5. Outputs the instance's public IP and SSH connection details

To use this configuration:
1. Initialize Terraform: `terraform init`
2. Apply the configuration: `terraform apply`
3. Save the private key from the output to a .pem file
4. Use the SSH connection string from the output to connect to your instance

The configuration uses the smallest instance size (nano_2_0) for cost efficiency, but you can modify the bundle_id to use larger instances if needed. The instance will be created in the us-east-1 region, specifically in the us-east-1a availability zone.