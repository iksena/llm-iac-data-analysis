resource "aws_fis_experiment_template" "api_fault" {
  description = "api_fault"
  role_arn    = aws_iam_role.fis.arn

  stop_condition {
    source = "none"
  }

  log_configuration {
    log_schema_version = 2

    s3_configuration {
      bucket_name = aws_s3_bucket.fis_logs.bucket
    }
  }

  action {
    action_id   = "aws:fis:inject-api-internal-error"
    name        = "ApiFault"
    start_after = []

    parameter {
      key   = "duration"
      value = "PT3M"
    }
    parameter {
      key   = "operations"
      value = "DescribeImages"
    }
    parameter {
      key   = "percentage"
      value = "75"
    }
    parameter {
      key   = "service"
      value = "ec2"
    }

    target {
      key   = "Roles"
      value = "hello-fis"
    }
  }


  target {
    name = "hello-fis"
    resource_arns = [
      aws_iam_role.ec2.arn,
    ]
    resource_type  = "aws:iam:role"
    selection_mode = "ALL"
  }



}