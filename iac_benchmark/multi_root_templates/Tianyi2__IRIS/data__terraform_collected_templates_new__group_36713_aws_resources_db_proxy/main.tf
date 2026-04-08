resource "aws_db_proxy" "this" {
  region                 = var.region
  name                   = var.name
  debug_logging          = var.debug_logging
  engine_family          = var.engine_family
  idle_client_timeout    = var.idle_client_timeout
  require_tls            = var.require_tls
  role_arn               = var.role_arn
  vpc_security_group_ids = var.vpc_security_group_ids
  vpc_subnet_ids         = var.vpc_subnet_ids
  tags                   = var.tags

  dynamic "auth" {
    for_each = var.auth
    content {
      auth_scheme               = auth.value.auth_scheme
      client_password_auth_type = auth.value.client_password_auth_type
      description               = auth.value.description
      iam_auth                  = auth.value.iam_auth
      secret_arn                = auth.value.secret_arn
      username                  = auth.value.username
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}