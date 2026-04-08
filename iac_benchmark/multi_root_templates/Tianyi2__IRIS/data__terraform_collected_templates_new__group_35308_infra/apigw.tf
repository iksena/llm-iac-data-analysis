module "orgId_path_part" {
  source             = "git@github.com:moggiez/terraform-modules.git//lambda_gateway"
  api                = aws_api_gateway_rest_api._
  lambda             = module.playbooks_lambda.lambda
  http_methods       = toset([])
  resource_path_part = "{organisationId}"
  authorizer         = local.authorizer
}

module "orgId_gateway_cors" {
  source          = "git@github.com:moggiez/terraform-modules.git//api_gateway_enable_cors"
  api_id          = aws_api_gateway_rest_api._.id
  api_resource_id = module.orgId_path_part.api_resource.id
}

module "playbooks_path_part" {
  source             = "git@github.com:moggiez/terraform-modules.git//lambda_gateway"
  api                = aws_api_gateway_rest_api._
  parent_resource    = module.orgId_path_part.api_resource
  lambda             = module.playbooks_lambda.lambda
  http_methods       = toset(["GET", "POST"])
  resource_path_part = "playbooks"
  authorizer         = local.authorizer
}

module "playbooks_gateway_cors" {
  source          = "git@github.com:moggiez/terraform-modules.git//api_gateway_enable_cors"
  api_id          = aws_api_gateway_rest_api._.id
  api_resource_id = module.playbooks_path_part.api_resource.id
}

module "playbookId_path_part" {
  source             = "git@github.com:moggiez/terraform-modules.git//lambda_gateway"
  api                = aws_api_gateway_rest_api._
  parent_resource    = module.playbooks_path_part.api_resource
  lambda             = module.playbooks_lambda.lambda
  http_methods       = toset(["GET", "POST", "PUT", "DELETE"])
  resource_path_part = "{playbookId}"
  authorizer         = local.authorizer
}

module "playbookId_gateway_cors" {
  source          = "git@github.com:moggiez/terraform-modules.git//api_gateway_enable_cors"
  api_id          = aws_api_gateway_rest_api._.id
  api_resource_id = module.playbookId_path_part.api_resource.id
}

module "playbooks_versions_path_part" {
  source             = "git@github.com:moggiez/terraform-modules.git//lambda_gateway"
  api                = aws_api_gateway_rest_api._
  parent_resource    = module.playbookId_path_part.api_resource
  lambda             = module.playbooks_lambda.lambda
  http_methods       = toset(["GET"])
  resource_path_part = "versions"
  authorizer         = local.authorizer
}

module "playbooks_versions_cors" {
  source          = "git@github.com:moggiez/terraform-modules.git//api_gateway_enable_cors"
  api_id          = aws_api_gateway_rest_api._.id
  api_resource_id = module.playbooks_versions_path_part.api_resource.id
}

module "version_path_path" {
  source             = "git@github.com:moggiez/terraform-modules.git//lambda_gateway"
  api                = aws_api_gateway_rest_api._
  parent_resource    = module.playbooks_versions_path_part.api_resource
  lambda             = module.playbooks_lambda.lambda
  http_methods       = toset(["GET"])
  resource_path_part = "{version}"
  authorizer         = local.authorizer
}

module "version_cors" {
  source          = "git@github.com:moggiez/terraform-modules.git//api_gateway_enable_cors"
  api_id          = aws_api_gateway_rest_api._.id
  api_resource_id = module.version_path_path.api_resource.id
}