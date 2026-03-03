provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "redshift_sns_role" {
  name = "RedshiftSNSRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "redshift_sns_policy" {
  name = "RedshiftSNSPolicy"
  role = aws_iam_role.redshift_sns_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sns:Publish"
        Resource = aws_sns_topic.redshift_events.arn
      }
    ]
  })
}

resource "aws_sns_topic" "redshift_events" {
  name = "redshift-events-topic"
}

resource "aws_redshift_parameter_group" "example" {
  name   = "example-parameter-group"
  family = "redshift-1.0"

  parameter {
    name  = "require_ssl"
    value = "true"
  }
}

resource "aws_redshift_cluster" "example" {
  cluster_identifier = "example-cluster"
  node_type          = "dc2.large"
  master_username    = "adminuser"
  master_password    = "Admin12345"
  cluster_type       = "single-node"
  iam_roles          = [aws_iam_role.redshift_sns_role.arn]

  depends_on = [aws_redshift_parameter_group.example]
}

resource "aws_redshift_event_subscription" "example" {
  name                   = "example-event-subscription"
  sns_topic_arn          = aws_sns_topic.redshift_events.arn
  source_type            = "cluster-parameter-group"
  source_ids             = [aws_redshift_parameter_group.example.name]
  event_categories       = ["configuration change"]
  severity               = "INFO"
  enabled                = true
}