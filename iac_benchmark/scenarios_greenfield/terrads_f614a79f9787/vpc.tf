# -----
# Pulls data for AZs in the region

data "aws_availability_zones" "available_azs" {}

## VPC and Subnet ##

resource "aws_vpc" "vpc" {
  cidr_block            = var.vpc_cidr
  assign_generated_ipv6_cidr_block  = false
  enable_dns_support    = true
  enable_dns_hostnames  = true
  tags                  = merge(
    local.common_tags, 
    { Name = "${var.app_shortcode}_${var.vpc_name}" }
  )
}

resource "aws_subnet" "priv_subnet" {
  vpc_id                = aws_vpc.vpc.id
  availability_zone     = data.aws_availability_zones.available_azs.names[0]
  cidr_block            = var.priv_subnet_cidr
  map_public_ip_on_launch = false
  tags                  = merge(
    local.common_tags, 
    { Name = var.priv_subnet_name }
  )
}

## VPC Endpoint to AWS Services required by SSM Session Manager ##

# com.amazonaws.region.ssm: The endpoint for the Systems Manager service
resource "aws_vpc_endpoint" "vpce_ssm" {
  service_name          = "com.amazonaws.${var.aws_region}.ssm"
  vpc_id                = aws_vpc.vpc.id
  subnet_ids            = [ aws_subnet.priv_subnet.id ]
  private_dns_enabled   = true

  auto_accept           = true
  vpc_endpoint_type     = "Interface"

  security_group_ids    = [ aws_security_group.svc_vpce_sg.id ]

  policy                = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "SSMRequiredPermissions"
        Principal = "*"
        Action = [
          "ssm:UpdateInstanceInformation",
          "ssm:ListInstanceAssociations", 
          "ssm:DescribeInstanceProperties", 
          "ssm:DescribeDocumentParameters", 
        ]
        Effect = "Allow"
        Resource = "*"
      },
    ]        
  })

  tags                  = merge(
    local.common_tags, 
    { Name = "${var.app_shortcode}_ssm" }
  )
}

# com.amazonaws.region.ec2messages: Systems Manager uses this endpoint to make calls from SSM Agent to the Systems Manager service
resource "aws_vpc_endpoint" "vpce_ec2_messages" {
  service_name          = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_id                = aws_vpc.vpc.id
  subnet_ids            = [ aws_subnet.priv_subnet.id ]
  private_dns_enabled   = true

  auto_accept           = true
  vpc_endpoint_type     = "Interface"

  security_group_ids    = [ aws_security_group.svc_vpce_sg.id ]

  policy                = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "SSMRequiredPermissions"
        Principal = "*"
        Action = [
          "ec2messages:AcknowledgeMessage",
          "ec2messages:DeleteMessage",
          "ec2messages:FailMessage",
          "ec2messages:GetEndpoint",
          "ec2messages:GetMessages",
          "ec2messages:SendReply",
        ]
        Effect = "Allow"
        Resource = "*"
      },
    ]        
  })

  tags                  = merge(
    local.common_tags, 
    { Name = "${var.app_shortcode}_ec2_messages" }
  )
}

# com.amazonaws.region.ssmmessages: This endpoint is required to connect to your instances through a secure data channel using Session Manager 
resource "aws_vpc_endpoint" "vpce_ssm_messages" {
  service_name          = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_id                = aws_vpc.vpc.id
  subnet_ids            = [ aws_subnet.priv_subnet.id ]
  private_dns_enabled   = true

  auto_accept           = true
  vpc_endpoint_type     = "Interface"

  security_group_ids    = [ aws_security_group.svc_vpce_sg.id ]

  policy                = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "SSMRequiredPermissions"
        Principal = "*"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
        ]
        Effect = "Allow"
        Resource = "*"
      },
    ]        
  })

  tags                  = merge(
    local.common_tags, 
    { Name = "${var.app_shortcode}_ssm_messages" }
  )
}

resource "aws_vpc_endpoint" "vpce_cw_logs" {
  service_name          = "com.amazonaws.${var.aws_region}.logs"
  vpc_id                = aws_vpc.vpc.id
  subnet_ids            = [ aws_subnet.priv_subnet.id ]
  private_dns_enabled   = true

  auto_accept           = true
  vpc_endpoint_type     = "Interface"

  security_group_ids    = [ aws_security_group.svc_vpce_sg.id ]

  policy                = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "SSMRequiredPermissions"
        Principal = "*"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = "*"
      },
    ]        
  })

  tags                  = merge(
    local.common_tags, 
    { Name = "${var.app_shortcode}_cw_logs" }
  )
}

