resource "aws_fis_experiment_template" "ec2_terminate" {
  description = "ec2_terminate"
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
    name      = "TerminateInstances"
    action_id = "aws:ec2:terminate-instances"

    target {
      key   = "Instances"
      value = local.name
    }
  }

  target {
    name           = local.name
    resource_type  = "aws:ec2:instance"
    selection_mode = "COUNT(1)"

    resource_tag {
      key   = "Name"
      value = local.name
    }
  }
}