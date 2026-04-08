resource "aws_s3control_access_point_policy" "this" {
  access_point_arn = var.access_point_arn
  policy           = var.policy
  region           = var.region
}