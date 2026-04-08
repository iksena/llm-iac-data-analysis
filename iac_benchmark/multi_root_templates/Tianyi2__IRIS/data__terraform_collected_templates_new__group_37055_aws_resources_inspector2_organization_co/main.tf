resource "aws_inspector2_organization_configuration" "this" {
  region = var.region

  auto_enable {
    ec2             = var.auto_enable_ec2
    ecr             = var.auto_enable_ecr
    code_repository = var.auto_enable_code_repository
    lambda          = var.auto_enable_lambda
    lambda_code     = var.auto_enable_lambda_code
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}