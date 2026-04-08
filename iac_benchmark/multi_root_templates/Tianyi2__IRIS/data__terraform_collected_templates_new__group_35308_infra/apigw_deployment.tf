
resource "aws_api_gateway_deployment" "api_deployment" {
  for_each = local.stages

  depends_on = [
    module.orgId_path_part,
    module.playbooks_path_part,
    module.playbookId_path_part,
    module.playbooks_versions_path_part,
    module.version_path_path
  ]

  rest_api_id = aws_api_gateway_rest_api._.id
  description = each.value


  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = sha1(timestamp())
  }
}

resource "aws_api_gateway_stage" "api_stage" {
  for_each = aws_api_gateway_deployment.api_deployment

  deployment_id = each.value.id
  rest_api_id   = aws_api_gateway_rest_api._.id
  stage_name    = each.value.description

  lifecycle {
    create_before_destroy = true
  }
}

module "playbook_api_subdomain_mapping" {
  source          = "git@github.com:moggiez/terraform-modules.git//api_subdomain_mapping"
  depends_on      = [aws_acm_certificate._, aws_api_gateway_stage.api_stage]
  api             = aws_api_gateway_rest_api._
  api_stage_name  = local.stage
  api_subdomain   = "playbooks-api"
  certificate_arn = aws_acm_certificate._.arn
  domain_name     = "moggies.io"
  hosted_zone_id  = local.hosted_zone.zone_id
}