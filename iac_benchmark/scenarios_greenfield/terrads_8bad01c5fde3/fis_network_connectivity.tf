resource "aws_fis_experiment_template" "network_connectivity" {
  description = "network_connectivity"
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
    name      = "DisruptConnectivity"
    action_id = "aws:network:disrupt-connectivity"

    target {
      key   = "Subnets"
      value = local.name
    }

    parameter {
      key   = "scope"
      value = "all"
    }

    parameter {
      key   = "duration"
      value = "PT1M" # one minute
    }
  }

  target {
    name           = local.name
    resource_type  = "aws:ec2:subnet"
    selection_mode = "COUNT(1)"


    resource_tag {
      key   = "Name"
      value = local.name
    }
  }
}