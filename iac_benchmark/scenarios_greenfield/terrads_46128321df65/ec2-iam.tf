# Instance Pofile role and policy
resource "aws_iam_role" "ec2_role" {
  for_each = {
    for k, v in lookup(local.ec2, var.environment) : k => v
  }
  name               = "${each.key}-ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags               = merge(local.global_tags, {})
}

resource "aws_iam_instance_profile" "ec2_profile" {
  for_each = {
    for k, v in lookup(local.ec2, var.environment) : k => v
  }
  provider = aws.dublin
  name     = "${each.key}-ec2-instance-profile"
  role     = aws_iam_role.ec2_role[each.key].name
  tags     = merge(local.global_tags, {})
}

resource "aws_iam_role_policy" "rds_policy" {
  for_each = {
    for k, v in lookup(local.ec2, var.environment) : k => v
    if contains(try(v.policies, []), "rds")
  }

  name   = "${each.key}-ec2-rds-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "rds:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
  role   = aws_iam_role.ec2_role[each.key].id
}

# EventBridge role and policy
resource "aws_iam_policy" "eventbridge_ec2_policy" {
  name        = "eventbridge_ec2_policy"
  description = "Policy to allow EventBridge to stop and start EC2 instances"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:RebootInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "eventbridge_ec2_role" {
  name               = "eventbridge_ec2_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eventbridge_ec2_attachment" {
  role       = aws_iam_role.eventbridge_ec2_role.name
  policy_arn = aws_iam_policy.eventbridge_ec2_policy.arn
}