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