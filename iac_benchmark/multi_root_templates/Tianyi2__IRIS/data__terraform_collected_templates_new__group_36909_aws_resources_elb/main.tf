# Validation checks
locals {
  name_validation    = var.name == null || var.name_prefix == null ? null : "Only one of name or name_prefix can be specified"
  network_validation = (var.availability_zones == null) != (var.subnets == null) ? null : "Exactly one of availability_zones or subnets must be specified"
}

resource "terraform_data" "validation" {
  lifecycle {
    precondition {
      condition     = local.name_validation == null
      error_message = "resource_aws_elb: Conflicts between name and name_prefix. Only one of name or name_prefix can be specified."
    }
    precondition {
      condition     = local.network_validation == null
      error_message = "resource_aws_elb: Exactly one of availability_zones or subnets must be specified."
    }
  }
}

resource "aws_elb" "this" {
  depends_on                  = [terraform_data.validation]
  region                      = var.region
  name                        = var.name
  name_prefix                 = var.name_prefix
  availability_zones          = var.availability_zones
  security_groups             = var.security_groups
  subnets                     = var.subnets
  instances                   = var.instances
  internal                    = var.internal
  cross_zone_load_balancing   = var.cross_zone_load_balancing
  idle_timeout                = var.idle_timeout
  connection_draining         = var.connection_draining
  connection_draining_timeout = var.connection_draining_timeout
  desync_mitigation_mode      = var.desync_mitigation_mode
  tags                        = var.tags

  dynamic "access_logs" {
    for_each = var.access_logs != null ? [var.access_logs] : []
    content {
      bucket        = access_logs.value.bucket
      bucket_prefix = access_logs.value.bucket_prefix
      interval      = access_logs.value.interval
      enabled       = access_logs.value.enabled
    }
  }

  dynamic "listener" {
    for_each = var.listener
    content {
      instance_port      = listener.value.instance_port
      instance_protocol  = listener.value.instance_protocol
      lb_port            = listener.value.lb_port
      lb_protocol        = listener.value.lb_protocol
      ssl_certificate_id = listener.value.ssl_certificate_id
    }
  }

  dynamic "health_check" {
    for_each = var.health_check != null ? [var.health_check] : []
    content {
      healthy_threshold   = health_check.value.healthy_threshold
      unhealthy_threshold = health_check.value.unhealthy_threshold
      target              = health_check.value.target
      interval            = health_check.value.interval
      timeout             = health_check.value.timeout
    }
  }
}