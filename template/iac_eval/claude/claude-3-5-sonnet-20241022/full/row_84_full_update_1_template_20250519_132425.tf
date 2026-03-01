I'll help you create a Terraform configuration that implements a Route 53 weighted routing policy to direct traffic between two endpoints based on their congestion levels. This configuration will:

1. Create a Route 53 hosted zone named "primary"
2. Create health checks for both endpoints
3. Set up weighted DNS records for endpoints in us-east-1 and eu-central-1
4. Configure the routing policy to distribute traffic based on weights

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create Route 53 zone
resource "aws_route53_zone" "primary" {
  name = "primary.example.com"
}

# Create health check for US endpoint
resource "aws_route53_health_check" "us_health" {
  fqdn              = "us-endpoint.primary.example.com"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "us-health-check"
  }
}

# Create health check for EU endpoint
resource "aws_route53_health_check" "eu_health" {
  fqdn              = "eu-endpoint.primary.example.com"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "eu-health-check"
  }
}

# Create weighted record for US endpoint
resource "aws_route53_record" "us_endpoint" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.primary.example.com"
  type    = "A"
  
  weighted_routing_policy {
    weight = 50
  }

  set_identifier = "us-east"
  health_check_id = aws_route53_health_check.us_health.id

  alias {
    name                   = "us-endpoint.primary.example.com"
    zone_id                = aws_route53_zone.primary.zone_id
    evaluate_target_health = true
  }
}

# Create weighted record for EU endpoint
resource "aws_route53_record" "eu_endpoint" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.primary.example.com"
  type    = "A"
  
  weighted_routing_policy {
    weight = 50
  }

  set_identifier = "eu-central"
  health_check_id = aws_route53_health_check.eu_health.id

  alias {
    name                   = "eu-endpoint.primary.example.com"
    zone_id                = aws_route53_zone.primary.zone_id
    evaluate_target_health = true
  }
}

# Create A record for US endpoint
resource "aws_route53_record" "us_endpoint_target" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "us-endpoint.primary.example.com"
  type    = "A"
  ttl     = "300"
  records = ["10.0.0.1"] # Replace with actual IP address
}

# Create A record for EU endpoint
resource "aws_route53_record" "eu_endpoint_target" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "eu-endpoint.primary.example.com"
  type    = "A"
  ttl     = "300"
  records = ["10.0.0.2"] # Replace with actual IP address
}
</iac_template>

This configuration creates:
1. A Route 53 hosted zone named "primary.example.com"
2. Health checks for both US and EU endpoints
3. Weighted DNS records that point to endpoints in us-east-1 and eu-central-1
4. The actual A records for both endpoints

The routing policy is configured with:
- Equal weights (50/50) for both endpoints
- Health checks to monitor endpoint availability
- Alias records that evaluate target health
- Set identifiers to distinguish between the regions

Note: You'll need to replace the example IP addresses (10.0.0.1 and 10.0.0.2) with your actual endpoint IP addresses. Also, the domain "primary.example.com" is used as an example - you should replace it with your actual domain name.

The health checks will monitor the endpoints, and Route 53 will automatically route traffic to the healthy endpoints based on the weighted routing policy. If an endpoint becomes unhealthy, Route 53 will route all traffic to the healthy endpoint.