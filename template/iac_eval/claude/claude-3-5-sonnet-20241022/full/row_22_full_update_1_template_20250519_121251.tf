I'll help you create a Terraform configuration to set up a Pointer (PTR) record for reverse DNS using AWS Route 53. This configuration will:

1. Create a Route 53 hosted zone for reverse DNS
2. Create a PTR record pointing to the specified domain name
3. Use AWS as the provider in the us-east-1 region

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create Route 53 Reverse DNS Zone
resource "aws_route53_zone" "reverse_zone" {
  name = "1.168.192.in-addr.arpa" # Example reverse DNS zone for 192.168.1.0/24

  tags = {
    Name = "reverse_zone"
  }
}

# Create PTR Record
resource "aws_route53_record" "ptr_record" {
  zone_id = aws_route53_zone.reverse_zone.zone_id
  name    = "10.1.168.192.in-addr.arpa" # Example: PTR record for IP 192.168.1.10
  type    = "PTR"
  ttl     = "300"
  records = ["host.example53.com"]
}

# Output the name servers for the reverse zone
output "reverse_zone_name_servers" {
  value = aws_route53_zone.reverse_zone.name_servers
}
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider for the us-east-1 region
2. Creates a reverse DNS zone (1.168.192.in-addr.arpa) for the 192.168.1.0/24 network
3. Creates a PTR record for the IP address 192.168.1.10 pointing to host.example53.com
4. Includes an output to display the name servers for the reverse zone

Note that this example uses the 192.168.1.0/24 network for demonstration. You should adjust the reverse DNS zone name and PTR record name according to your actual IP address range. The format for reverse DNS is the IP address in reverse order with ".in-addr.arpa" appended.

The TTL (Time To Live) is set to 300 seconds (5 minutes), which you can adjust based on your needs. The configuration includes proper tagging for the reverse zone for better resource management.

Remember that to use Route 53 for reverse DNS, you typically need to coordinate with your ISP or AWS (if using AWS IP addresses) as they need to delegate the reverse DNS zone to your Route 53 name servers.