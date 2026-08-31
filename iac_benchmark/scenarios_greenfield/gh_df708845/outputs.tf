# Terraform Outputs

output "website_url" {
  description = "URL of the deployed website"
  value       = "https://${var.domain_name}"
}

output "api_url" {
  description = "URL of the API endpoint"
  value       = "https://${var.api_subdomain}.${var.domain_name}"
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.website.id
}

output "s3_website_bucket" {
  description = "S3 bucket name for website"
  value       = aws_s3_bucket.website.bucket
}

output "s3_assets_bucket" {
  description = "S3 bucket name for assets"
  value       = aws_s3_bucket.assets.bucket
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.app.name
}

output "database_endpoint" {
  description = "RDS cluster endpoint"
  value       = aws_rds_cluster.main.endpoint
  sensitive   = true
}

output "load_balancer_dns" {
  description = "Load balancer DNS name"
  value       = aws_lb.main.dns_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}

# Cost estimation outputs
output "estimated_monthly_cost" {
  description = "Estimated monthly cost breakdown"
  value = {
    fargate_spot = "~$10-15 (256 CPU, 512 MB, 1 task)"
    aurora_serverless = "~$5-10 (0.5-1 ACU)"
    alb = "~$16 (base cost)"
    nat_gateway = "~$32 (single NAT)"
    cloudfront = "~$1-5 (depending on traffic)"
    route53 = "~$0.50 (hosted zone)"
    s3 = "~$1-5 (depending on storage)"
    total_estimated = "~$65-85/month"
    note = "Costs vary based on usage. Spot instances can reduce Fargate costs by up to 70%"
  }
}