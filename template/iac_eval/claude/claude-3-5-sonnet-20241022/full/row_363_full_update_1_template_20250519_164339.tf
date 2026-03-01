I'll help you create a Terraform configuration to deploy an Amazon Lightsail instance with a static IPv4 IP address. This configuration will:

1. Create an AWS Lightsail instance
2. Create a static IP address
3. Attach the static IP to the Lightsail instance

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create Lightsail Instance
resource "aws_lightsail_instance" "example_instance" {
  name              = "example-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"

  tags = {
    Environment = "Development"
  }
}

# Create Static IP
resource "aws_lightsail_static_ip" "example_static_ip" {
  name = "example-static-ip"
}

# Attach Static IP to Instance
resource "aws_lightsail_static_ip_attachment" "example_static_ip_attachment" {
  static_ip_name = aws_lightsail_static_ip.example_static_ip.name
  instance_name  = aws_lightsail_instance.example_instance.name
}

# Output the Static IP address
output "static_ip_address" {
  value = aws_lightsail_static_ip.example_static_ip.ip_address
  description = "The static IP address assigned to the Lightsail instance"
}
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider for the us-east-1 region
2. Creates a Lightsail instance using:
   - Amazon Linux 2 as the blueprint
   - The "nano" bundle (cheapest option)
   - Deploys in the us-east-1a availability zone
3. Creates a static IP address
4. Attaches the static IP to the Lightsail instance
5. Outputs the static IP address for reference

The instance will be accessible via the static IP address once deployment is complete. The static IP will remain the same even if the instance is stopped and started again.

To deploy this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Remember that Lightsail instances and static IPs may incur costs in your AWS account.