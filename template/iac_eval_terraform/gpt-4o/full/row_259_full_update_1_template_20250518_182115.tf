To fulfill the business need, we will create an AWS Redshift cluster using Terraform. The configuration will include defining a Redshift cluster with example parameters such as node type, number of nodes, and database name. Additionally, we will set up an SNS topic to handle notifications for events associated with the Redshift parameter group. An IAM role will be created to allow Redshift to communicate with other AWS services if needed. The configuration will be deployed in the `us-west-2` region.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "redshift_role" {
  name = "redshift-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "redshift_policy_attachment" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_sns_topic" "redshift_notifications" {
  name = "redshift-event-notifications"
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
  cluster_identifier      = "example-cluster"
  node_type               = "dc2.large"
  number_of_nodes         = 2
  database_name           = "exampledb"
  master_username         = "masteruser"
  master_password         = "MasterUserPassword1"
  iam_roles               = [aws_iam_role.redshift_role.arn]
  cluster_parameter_group_name = aws_redshift_parameter_group.example.name

  depends_on = [aws_iam_role_policy_attachment.redshift_policy_attachment]
}

resource "aws_redshift_event_subscription" "example" {
  name                   = "example-event-subscription"
  sns_topic_arn          = aws_sns_topic.redshift_notifications.arn
  source_type            = "cluster-parameter-group"
  source_ids             = [aws_redshift_parameter_group.example.name]
  event_categories       = ["configuration change", "failure"]
  severity               = "ERROR"
  enabled                = true
}
```
</iac_template>