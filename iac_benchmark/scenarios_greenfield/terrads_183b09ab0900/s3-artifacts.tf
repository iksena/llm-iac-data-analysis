#
# cache s3 bucket
#
#resource "aws_s3_bucket" "codebuild-cache" {
#  bucket = local.codebuild-cache-s3
#  acl    = "private"
#}
#
#resource "aws_s3_bucket" "demo-artifacts" {
#  bucket = local.demo-artifacts-s3
#  acl    = "private"
#
#  lifecycle_rule {
#    id      = "clean-up"
#    enabled = "true"
#
#    expiration {
#      days = 30
#    }
#  }
#}
#
