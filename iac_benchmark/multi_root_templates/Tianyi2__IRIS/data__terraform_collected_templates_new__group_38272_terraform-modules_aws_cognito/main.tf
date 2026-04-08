##########################
#     Naming Config      #
##########################
module "resource_name_prefix" {
  source = "git@github.com:UKHSA-Internal/devops-terraform-modules.git//terraform-modules/helpers/resource-name-prefix?ref=TF/helpers/resource-name-prefix/vALPHA_0.0.2"

  name = var.name
  tags = var.tags
}


##########################
#         Cognito        #
##########################
resource "aws_cognito_user_pool" "cognito_user_pool" {
  name                     = "${module.resource_name_prefix.resource_name}-cognito-up"
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  dynamic "schema" {
    for_each = var.schema
    content {
      attribute_data_type      = schema.value["attribute_data_type"]
      developer_only_attribute = schema.value["developer_only_attribute"]
      mutable                  = schema.value["mutable"]
      name                     = schema.value["name"]
      required                 = schema.value["required"]

      # string_attribute_constraints only requeried when attribute_data_type is string
      dynamic "string_attribute_constraints" {
        for_each = schema.value["attribute_data_type"] == "String" ? [1] : []
        content {
          min_length = 0
          max_length = 2048
        }
      }
    }
  }

  lambda_config {
    pre_sign_up = var.lambda_auth_challenge_arn
  }

  password_policy {
    minimum_length                   = var.password_min_length
    require_lowercase                = true
    require_uppercase                = true
    require_symbols                  = true
    require_numbers                  = true
    temporary_password_validity_days = var.temp_password_validity_days
  }

  account_recovery_setting {
    dynamic "recovery_mechanism" {
      for_each = var.recovery_mechanism
      content {
        name     = recovery_mechanism.value["name"]
        priority = recovery_mechanism.value["priority"]
      }
    }
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "${module.resource_name_prefix.resource_name}-cognito-client"

  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id

  generate_secret              = true
  supported_identity_providers = var.supported_identity_providers
  refresh_token_validity       = var.token_validity
  access_token_validity        = var.token_validity
  id_token_validity            = var.token_validity

  prevent_user_existence_errors        = "ENABLED"
  explicit_auth_flows                  = var.explicit_auth_flows
  callback_urls                        = [var.callback_url]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = var.allowed_oauth_scopes
  allowed_oauth_flows                  = var.allowed_oauth_flows
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = var.domain
  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id
}

##########################
#          IAM           #
##########################
data "aws_caller_identity" "current" {}
resource "aws_lambda_permission" "allow_cognito" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.cognito_user_pool.arn
}