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