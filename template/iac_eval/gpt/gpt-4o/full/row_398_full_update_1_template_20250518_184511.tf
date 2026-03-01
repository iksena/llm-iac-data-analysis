To fulfill the business need, we will create an AWS Application Load Balancer (ALB) with an authentication action using Amazon Cognito. This setup will involve creating a Cognito User Pool and an ALB listener rule that uses the "authenticate-cognito" action to authenticate users. The configuration will include the necessary IAM roles and policies to allow the ALB to interact with Cognito. We will also set up a basic VPC with subnets and security groups to host the ALB.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

data "aws_availability_zones" "available" {}

resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cognito_user_pool" "main" {
  name = "example_user_pool"
}

resource "aws_cognito_user_pool_client" "main" {
  name         = "example_user_pool_client"
  user_pool_id = aws_cognito_user_pool.main.id
  callback_urls = ["https://example.com/callback"]
  allowed_oauth_flows = ["code"]
  allowed_oauth_scopes = ["email", "openid", "profile"]
  allowed_oauth_flows_user_pool_client = true
}

resource "aws_lb" "main" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.main[*].id
}

resource "aws_lb_target_group" "main" {
  name     = "example-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "authenticate-cognito"

    authenticate_cognito {
      user_pool_arn       = aws_cognito_user_pool.main.arn
      user_pool_client_id = aws_cognito_user_pool_client.main.id
      user_pool_domain    = aws_cognito_user_pool.main.endpoint
    }
  }
}

resource "aws_iam_role" "alb_role" {
  name = "alb-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticloadbalancing.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "alb_policy" {
  name   = "alb-policy"
  role   = aws_iam_role.alb_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cognito-idp:DescribeUserPool",
          "cognito-idp:ListUsers",
          "cognito-idp:AdminGetUser"
        ]
        Effect   = "Allow"
        Resource = aws_cognito_user_pool.main.arn
      }
    ]
  })
}
```
</iac_template>