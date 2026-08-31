resource "aws_fis_experiment_template" "ebs_pause" {
  description = "ebs_pause"
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
    name      = "EbsPause"
    action_id = "aws:ebs:pause-volume-io"

    target {
      key   = "Volumes"
      value = local.name
    }

    parameter {
      key   = "duration"
      value = "PT1M"
    }
  }

  target {
    name           = local.name
    resource_type  = "aws:ec2:ebs-volume"
    selection_mode = "COUNT(1)"

    resource_tag {
      key   = "Name"
      value = local.name
    }

    parameters = {
      availabilityZoneIdentifier = "us-east-1a"
    }

  }
}