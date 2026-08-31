
resource "aws_iam_role" "iam_role" {
  name = "centricity-airflow-role-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "mwaa"
        Principal = {
          Service = [
            "airflow-env.amazonaws.com",
            "airflow.amazonaws.com"
          ]
        }
      },
    ]
  })

  tags = merge(local.tags, {
    Name = "CentricityAirflow"
    Environment = var.environment
  })
}


resource "aws_iam_policy" "iam_policy" {
  name   = "airflow-iam-${var.environment}"
  path   = "/"
  policy = data.aws_iam_policy_document.iam_policy_document.json
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}

resource "aws_mwaa_environment" "mwaa_environment" {
  source_bucket_arn     = aws_s3_bucket.s3_bucket.arn
  dag_s3_path           = "DAGs/"
  execution_role_arn    = aws_iam_role.iam_role.arn
  name                  = "CentricityAirflow${var.environment}"
  requirements_s3_path  = var.requirements_s3_path
  max_workers           = var.mwaa_max_workers
  webserver_access_mode = "PUBLIC_ONLY"
  environment_class = var.environment_class
  network_configuration {
    security_group_ids = [aws_security_group.mwaa.id]
    subnet_ids         = aws_subnet.private_subnets.*.id
  }

  logging_configuration {
    dag_processing_logs {
      enabled   = true
      log_level = "INFO"
    }

    scheduler_logs {
      enabled   = true
      log_level = "INFO"
    }

    task_logs {
      enabled   = true
      log_level = "INFO"
    }

    webserver_logs {
      enabled   = true
      log_level = "INFO"
    }

    worker_logs {
      enabled   = true
      log_level = "INFO"
    }
  }
  depends_on = [
    aws_nat_gateway.nat_gateways,
    aws_route_table.private_route_tables,
    aws_route_table.public_route_table,
    aws_subnet.private_subnets,
    aws_subnet.public_subnets,
    aws_route_table_association.private_route_table_associations,
    aws_route_table_association.public_route_table_associations
  ]
}