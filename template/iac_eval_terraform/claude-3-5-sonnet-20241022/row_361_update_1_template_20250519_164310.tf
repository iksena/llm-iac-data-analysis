provider "aws" {
  region = "us-east-1"
}

# Create Lightsail Instance
resource "aws_lightsail_instance" "example_instance" {
  name              = "example-lightsail-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"  # Smallest bundle: 1 vCPU, 512 MB RAM

  tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

# Output the public IP address
output "public_ip" {
  value       = aws_lightsail_instance.example_instance.public_ip_address
  description = "Public IP address of the Lightsail instance"
}

# Output the instance ARN
output "instance_arn" {
  value       = aws_lightsail_instance.example_instance.arn
  description = "ARN of the Lightsail instance"
}