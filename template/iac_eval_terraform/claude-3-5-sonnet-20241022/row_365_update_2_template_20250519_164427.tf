provider "aws" {
  region = "us-east-1"
}

# Generate SSH Key Pair locally
resource "tls_private_key" "lightsail_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Store private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.lightsail_key.private_key_pem
  filename        = "lightsail_key.pem"
  file_permission = "0600"
}

# Create Lightsail Key Pair using generated key
resource "aws_lightsail_key_pair" "main" {
  name       = "lightsail-key-pair"
  public_key = tls_private_key.lightsail_key.public_key_openssh
}

# Create Lightsail Instance
resource "aws_lightsail_instance" "server" {
  name              = "lightsail-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"
  key_pair_name     = aws_lightsail_key_pair.main.name

  tags = {
    Name = "lightsail-instance"
  }
}

# Create Static IP
resource "aws_lightsail_static_ip" "server_static_ip" {
  name = "server-static-ip"
}

# Attach Static IP
resource "aws_lightsail_static_ip_attachment" "server_static_ip_attachment" {
  static_ip_name = aws_lightsail_static_ip.server_static_ip.name
  instance_name  = aws_lightsail_instance.server.name
}

# Configure firewall
resource "aws_lightsail_instance_public_ports" "server_ports" {
  instance_name = aws_lightsail_instance.server.name

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }
}

# Outputs
output "public_ip" {
  value       = aws_lightsail_static_ip.server_static_ip.ip_address
  description = "Public IP address of the Lightsail instance"
}

output "ssh_command" {
  value       = "ssh -i lightsail_key.pem ec2-user@${aws_lightsail_static_ip.server_static_ip.ip_address}"
  description = "SSH command to connect to the instance"
}