resource "aws_fis_experiment_template" "cpu_stress" {
  description = "cpu_stress"
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
    name      = "CpuStress"
    action_id = "aws:ssm:send-command"

    parameter {
      key   = "documentArn"
      value = "arn:aws:ssm:us-east-1::document/AWSFIS-Run-CPU-Stress"
    }

    parameter {
      key = "documentParameters"
      value = jsonencode(
        {
          DurationSeconds     = "60"
          InstallDependencies = "True"
        }
      )
    }
    parameter {
      key   = "duration"
      value = "PT1M"
    }


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