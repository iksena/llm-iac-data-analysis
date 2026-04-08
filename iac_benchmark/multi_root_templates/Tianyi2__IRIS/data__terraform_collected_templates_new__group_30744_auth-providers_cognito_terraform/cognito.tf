# AWS Cognito User Pool and Identity Provider Configuration

# Cognito User Pool
resource "aws_cognito_user_pool" "main" {
  name = "${local.name_prefix}-user-pool"

  # Password policy
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  # User attributes
  alias_attributes = ["email"]
  
  username_attributes = ["email"]

  # Account recovery
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  # Email configuration
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  # User pool add-ons
  user_pool_add_ons {
    advanced_security_mode = "ENFORCED"
  }

  # Verification message template
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Your verification code for ${var.domain_name}"
    email_message        = "Your verification code is {####}"
  }

  # Auto-verified attributes
  auto_verified_attributes = ["email"]

  # Schema
  schema {
    attribute_data_type = "String"
    name               = "email"
    required           = true
    mutable           = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type = "String"
    name               = "name"
    required           = false
    mutable           = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  tags = local.common_tags
}

# Cognito User Pool Client
resource "aws_cognito_user_pool_client" "web_client" {
  name         = "${local.name_prefix}-web-client"
  user_pool_id = aws_cognito_user_pool.main.id

  # Client settings
  generate_secret = false # For public clients (SPA)
  
  # OAuth settings
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  
  # Callback URLs
  callback_urls = [
    "https://${var.domain_name}/auth/callback",
    "http://localhost:8080/auth/callback" # For local development
  ]
  
  logout_urls = [
    "https://${var.domain_name}/auth/logout",
    "http://localhost:8080/auth/logout"
  ]

  # Supported identity providers
  supported_identity_providers = ["COGNITO"]

  # Token validity
  access_token_validity  = 60    # 1 hour
  id_token_validity     = 60    # 1 hour
  refresh_token_validity = 30   # 30 days

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }

  # Prevent user existence errors
  prevent_user_existence_errors = "ENABLED"

  # Read and write attributes
  read_attributes  = ["email", "name", "email_verified"]
  write_attributes = ["email", "name"]

  # Explicit auth flows
  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

# Cognito User Pool Domain
resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${local.name_prefix}-auth"
  user_pool_id = aws_cognito_user_pool.main.id
}

# Optional: Custom domain (requires ACM certificate)
# resource "aws_cognito_user_pool_domain" "custom" {
#   domain          = "auth.${var.domain_name}"
#   certificate_arn = aws_acm_certificate.auth.arn
#   user_pool_id    = aws_cognito_user_pool.main.id
# }

# Identity Pool for AWS resource access
resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = "${local.name_prefix}-identity-pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.web_client.id
    provider_name           = aws_cognito_user_pool.main.endpoint
    server_side_token_check = false
  }

  tags = local.common_tags
}

# IAM role for authenticated users
resource "aws_iam_role" "authenticated" {
  name = "${local.name_prefix}-cognito-authenticated-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.main.id
          }
          "ForAnyValue:StringLike" = {
            "cognito-identity.amazonaws.com:amr" = "authenticated"
          }
        }
      }
    ]
  })

  tags = local.common_tags
}

# Policy for authenticated users (S3 access)
resource "aws_iam_role_policy" "authenticated_s3" {
  name = "${local.name_prefix}-cognito-authenticated-s3-policy"
  role = aws_iam_role.authenticated.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "${aws_s3_bucket.assets.arn}/photos/*",
          "${aws_s3_bucket.assets.arn}/documents/*"
        ]
      }
    ]
  })
}

# Attach role to identity pool
resource "aws_cognito_identity_pool_roles_attachment" "main" {
  identity_pool_id = aws_cognito_identity_pool.main.id

  roles = {
    "authenticated" = aws_iam_role.authenticated.arn
  }
}

# Store Cognito configuration in SSM
resource "aws_ssm_parameter" "cognito_user_pool_id" {
  name  = "/${local.name_prefix}/cognito-user-pool-id"
  type  = "String"
  value = aws_cognito_user_pool.main.id

  tags = local.common_tags
}

resource "aws_ssm_parameter" "cognito_client_id" {
  name  = "/${local.name_prefix}/cognito-client-id"
  type  = "String"
  value = aws_cognito_user_pool_client.web_client.id

  tags = local.common_tags
}

resource "aws_ssm_parameter" "cognito_domain" {
  name  = "/${local.name_prefix}/cognito-domain"
  type  = "String"
  value = "https://${aws_cognito_user_pool_domain.main.domain}.auth.${var.aws_region}.amazoncognito.com"

  tags = local.common_tags
}