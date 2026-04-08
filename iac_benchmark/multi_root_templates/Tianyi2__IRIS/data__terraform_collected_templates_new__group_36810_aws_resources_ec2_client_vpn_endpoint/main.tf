resource "aws_ec2_client_vpn_endpoint" "this" {
  authentication_options {
    type                           = var.authentication_options.type
    active_directory_id            = var.authentication_options.active_directory_id
    root_certificate_chain_arn     = var.authentication_options.root_certificate_chain_arn
    saml_provider_arn              = var.authentication_options.saml_provider_arn
    self_service_saml_provider_arn = var.authentication_options.self_service_saml_provider_arn
  }

  connection_log_options {
    enabled               = var.connection_log_options.enabled
    cloudwatch_log_group  = var.connection_log_options.cloudwatch_log_group
    cloudwatch_log_stream = var.connection_log_options.cloudwatch_log_stream
  }

  server_certificate_arn = var.server_certificate_arn

  client_cidr_block             = var.client_cidr_block
  description                   = var.description
  disconnect_on_session_timeout = var.disconnect_on_session_timeout
  dns_servers                   = var.dns_servers
  endpoint_ip_address_type      = var.endpoint_ip_address_type
  security_group_ids            = var.security_group_ids
  self_service_portal           = var.self_service_portal
  session_timeout_hours         = var.session_timeout_hours
  split_tunnel                  = var.split_tunnel
  tags                          = var.tags
  traffic_ip_address_type       = var.traffic_ip_address_type
  transport_protocol            = var.transport_protocol
  vpc_id                        = var.vpc_id
  vpn_port                      = var.vpn_port

  dynamic "client_connect_options" {
    for_each = var.client_connect_options != null ? [var.client_connect_options] : []
    content {
      enabled             = client_connect_options.value.enabled
      lambda_function_arn = client_connect_options.value.lambda_function_arn
    }
  }

  dynamic "client_login_banner_options" {
    for_each = var.client_login_banner_options != null ? [var.client_login_banner_options] : []
    content {
      enabled     = client_login_banner_options.value.enabled
      banner_text = client_login_banner_options.value.banner_text
    }
  }

  dynamic "client_route_enforcement_options" {
    for_each = var.client_route_enforcement_options != null ? [var.client_route_enforcement_options] : []
    content {
      enforced = client_route_enforcement_options.value.enforced
    }
  }
}