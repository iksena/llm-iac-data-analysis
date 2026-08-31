resource "aws_s3_bucket" "ecs_services_scheduler" {
  bucket        = "${var.resources_name}-${var.env}-ecs-services-scheduler"
  force_destroy = true
  tags          = local.tags
}

resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.ecs_services_scheduler.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "ecs_services_scheduler" {
  depends_on = [aws_s3_bucket_ownership_controls.ownership_controls]
  bucket     = aws_s3_bucket.ecs_services_scheduler.id
  acl        = "private"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.ecs_services_scheduler.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "ecs_services_scheduler" {
  bucket = aws_s3_bucket.ecs_services_scheduler.id

  rule {
    id     = "ecs-services-scheduler"
    status = "Enabled"

    noncurrent_version_expiration {
      newer_noncurrent_versions = 25
      noncurrent_days           = 14
    }

  }
}

resource "aws_s3_bucket_policy" "ecs_services_scheduler_bucket_policy" {
  bucket = aws_s3_bucket.ecs_services_scheduler.id
  policy = data.aws_iam_policy_document.allow_lambda.json
}

data "aws_iam_policy_document" "allow_lambda" {
  statement {
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        aws_iam_role.role.arn
      ]
    }
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
    ]
    resources = [
      aws_s3_bucket.ecs_services_scheduler.arn,
      "${aws_s3_bucket.ecs_services_scheduler.arn}/*",
    ]
  }
}

resource "aws_cloudwatch_log_group" "strt_ecs_services" {
  name              = "/aws/lambda/start-ecs-service-lambda"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "stop_ecs_services" {
  name              = "/aws/lambda/stop-ecs-service-lambda"
  retention_in_days = 30
}
