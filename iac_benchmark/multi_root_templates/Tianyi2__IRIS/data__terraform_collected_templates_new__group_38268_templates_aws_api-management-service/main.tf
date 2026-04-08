module "tags" {
  source = "git@github.com:UKHSA-Internal/devops-terraform-modules.git//terraform-modules/helpers/tags?ref=TF/helpers/tags/vALPHA_0.0.1"

  project     = var.project
  client      = var.client
  owner       = var.owner
  environment = var.environment
  additional_tags = {
    "Purpose" = "Proof of Concept"
  }
}

module "api_gateway" {
  source = "git@github.com:UKHSA-Internal/devops-terraform-modules.git//terraform-modules/aws/api-gateway?ref=TF/aws/api-gateway/vALPHA_0.0.6"

  name = var.name

  aws_region = var.aws_region

  # API Gateway
  stage_names       = ["prod", "dev"]
  allowed_ip_ranges = ["0.0.0.0/0"]

  endpoints = {
    example = {
      path          = "example"
      methods       = ["POST", "GET"]
      authorization = "AWS_IAM"
    },
    example2 = {
      path          = "example2"
      methods       = ["POST"]
      authorization = "CUSTOM"
    }
  }

  # Custom Authoirzation
  custom_auth_lambda = {
    runtime         = "python3.8"
    handler         = "lambda_function.lambda_handler"
    filename        = "custom_auth_lambda_payload.zip"
    authTokenHeader = "authToken" # header of the request container the token
    aws_region      = var.aws_region
  }

  # API Gateway Integration
  integration_uri  = aws_lambda_function.lambda.invoke_arn
  integration_type = "AWS_PROXY"

  log_retention_in_days = 1

  quota_settings = {
    limit  = 5000
    offset = 0
    period = "MONTH"
  }

  throttle_settings = {
    burst_limit = 200
    rate_limit  = 100
  }

  # API GW input valdiation
  model_schema = {
    name         = "Example"
    description  = "An example schema description"
    content_type = "application/json"
    schema = jsonencode({
      type       = "object",
      properties = {}
    })
  }

  # VPC Links
  create_vpc_link      = false
  vpc_link_target_arns = ["target_arn"]

  # Private Endpoints
  create_private_endpoint = false
  vpc_endpoint_ids        = ["my_vpc_id"]

  tags = module.tags.tags
}

module "waf" {
  source = "git@github.com:UKHSA-Internal/devops-terraform-modules.git//terraform-modules/aws/web-application-firewall?ref=TF/aws/web-application-firewall/vALPHA_0.0.2"

  name            = var.name
  waf_description = "API Gateway WAF"

  aws_region = var.aws_region

  # Web Application Firewall Config
  scope                    = "REGIONAL"
  sampled_requests_enabled = false

  # Resource association 
  association_resource_arns = module.api_gateway.stage_arns

  # Logging Config
  retention_in_days = 30

  tags = module.tags.tags
}

module "cloudfront_distribution" {
  source = "git@github.com:UKHSA-Internal/devops-terraform-modules.git//terraform-modules/aws/cloudfront-distribution?ref=TF/aws/cloudfront-distribution/vALPHA_0.0.3"

  # Naming Config
  name        = var.name
  description = "API Gateway"

  # CloudFront Distribution
  domain_name               = module.api_gateway.api_url
  allowed_methods           = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  cached_methods            = ["GET", "HEAD"]
  geo_restriction_locations = ["GB"]
  ttl                       = { min_ttl = 0, default_ttl = 3600, max_ttl = 86400 }

  # S3 Resources
  s3_acl           = "private"
  object_ownership = "BucketOwnerPreferred"

  tags = module.tags.tags
}
