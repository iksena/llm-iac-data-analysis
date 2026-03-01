To fulfill the business need, we will create an AWS Elastic File System (EFS) with a system policy. The EFS will be set up in a specified AWS region, and a system policy will be attached to it to define access permissions. We will also create an IAM role that allows the necessary permissions to manage the EFS. The Terraform configuration will include the AWS provider setup, the EFS resource, and the EFS policy.

<iac_template>

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_efs_file_system" "example" {
  creation_token = "example-efs"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "example-efs"
  }
}

resource "aws_efs_file_system_policy" "example_policy" {
  file_system_id = aws_efs_file_system.example.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientWrite"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "efs_role" {
  name = "efs-access-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "efs_policy" {
  name        = "efs-access-policy"
  description = "A policy to allow EFS access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:DescribeFileSystems",
        "elasticfilesystem:DescribeMountTargets",
        "elasticfilesystem:DescribeTags",
        "elasticfilesystem:CreateMountTarget",
        "elasticfilesystem:DeleteMountTarget"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "efs_role_policy_attachment" {
  role       = aws_iam_role.efs_role.name
  policy_arn = aws_iam_policy.efs_policy.arn
}
```

</iac_template>