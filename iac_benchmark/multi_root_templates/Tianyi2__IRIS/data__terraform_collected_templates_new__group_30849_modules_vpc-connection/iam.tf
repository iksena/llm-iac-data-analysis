locals {
  execution_role = (var.default_execution_role.enabled
    ? module.execution_role[0].arn
    : var.execution_role
  )
}


###################################################
# IAM Role for VPC Connection
###################################################

module "execution_role" {
  count = var.default_execution_role.enabled ? 1 : 0

  source  = "tedilabs/account/aws//modules/iam-role"
  version = "~> 0.33.0"

  name = coalesce(
    var.default_execution_role.name,
    "quicksight-vpc-connection-${local.metadata.name}",
  )
  path        = var.default_execution_role.path
  description = var.default_execution_role.description

  trusted_service_policies = [
    {
      services = ["quicksight.amazonaws.com"]
    }
  ]

  policies = var.default_execution_role.policies
  inline_policies = merge({
    "vpc-connection" = jsonencode(yamldecode(<<EOF
      Version: "2012-10-17"
      Statement:
      - Effect: "Allow"
        Action:
        - "ec2:CreateNetworkInterface"
        - "ec2:ModifyNetworkInterfaceAttribute"
        - "ec2:DeleteNetworkInterface"
        - "ec2:DescribeSubnets"
        - "ec2:DescribeSecurityGroups"
        Resource: ["*"]
    EOF
    ))
  }, var.default_execution_role.inline_policies)

  permissions_boundary = var.default_execution_role.permissions_boundary

  force_detach_policies = true
  resource_group = {
    enabled = false
  }
  module_tags_enabled = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}
