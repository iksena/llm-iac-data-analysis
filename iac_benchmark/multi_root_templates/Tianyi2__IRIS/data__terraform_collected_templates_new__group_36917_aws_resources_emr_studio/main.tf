resource "aws_emr_studio" "this" {
  auth_mode                   = var.auth_mode
  default_s3_location         = var.default_s3_location
  engine_security_group_id    = var.engine_security_group_id
  name                        = var.name
  service_role                = var.service_role
  subnet_ids                  = var.subnet_ids
  vpc_id                      = var.vpc_id
  workspace_security_group_id = var.workspace_security_group_id

  region                         = var.region
  description                    = var.description
  encryption_key_arn             = var.encryption_key_arn
  idp_auth_url                   = var.idp_auth_url
  idp_relay_state_parameter_name = var.idp_relay_state_parameter_name
  tags                           = var.tags
  user_role                      = var.user_role
}