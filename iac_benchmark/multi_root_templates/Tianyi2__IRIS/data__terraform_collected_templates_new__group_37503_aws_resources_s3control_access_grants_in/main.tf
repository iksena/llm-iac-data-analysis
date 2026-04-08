resource "aws_s3control_access_grants_instance_resource_policy" "this" {
  region     = var.region
  account_id = var.account_id
  policy     = var.policy
}