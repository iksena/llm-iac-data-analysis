# Source: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "github_actions" {
  name                 = "github_actions"
  max_session_duration = 3600

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${aws_iam_openid_connect_provider.github.arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:${var.github_account}/*"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "github_actions_ecr_policy" {
  role       = aws_iam_role.github_actions.id
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
}

resource "aws_iam_role_policy" "github_actions_ecs_deploy_policy" {
  name   = "github-actions-ecs-policy"
  role   = aws_iam_role.github_actions.id
  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"RegisterTaskDefinition",
      "Effect":"Allow",
      "Action":[
        "ecs:RegisterTaskDefinition",
        "ecs:DescribeTaskDefinition"
      ],
      "Resource":"*"
    },
    {
      "Sid":"PassRolesInTaskDefinition",
      "Effect":"Allow",
      "Action":[
        "iam:PassRole"
      ],
      "Resource":[
        "${aws_iam_role.ecs_task.arn}",
        "${aws_iam_role.ecs_task_execution.arn}"
      ]
    },
    {
      "Sid":"DeployService",
      "Effect":"Allow",
      "Action":[
        "ecs:UpdateService",
        "ecs:DescribeServices"
      ],
      "Resource": "*"
    },
    {
      "Sid":"CleanUpService",
      "Effect":"Allow",
      "Action":[
        "ecs:DescribeServices",
        "ecs:ListServices",
        "ecs:ListTaskDefinitions",
        "ecs:DeregisterTaskDefinition",
        "ecs:DeleteTaskDefinitions"
      ],
      "Resource": "*"
    }
  ]
}
  EOF
}
