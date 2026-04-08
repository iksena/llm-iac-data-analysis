resource "aws_lambda_function_url" "this" {
  function_name      = var.function_name
  authorization_type = var.authorization_type
  invoke_mode        = var.invoke_mode
  qualifier          = var.qualifier
  region             = var.region

  dynamic "cors" {
    for_each = var.cors != null ? [var.cors] : []
    content {
      allow_credentials = cors.value.allow_credentials
      allow_headers     = cors.value.allow_headers
      allow_methods     = cors.value.allow_methods
      allow_origins     = cors.value.allow_origins
      expose_headers    = cors.value.expose_headers
      max_age           = cors.value.max_age
    }
  }

  timeouts {
    create = "10m"
  }
}