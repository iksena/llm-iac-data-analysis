The Terraform program will create a basic AWS IAM user. This user will have a specified username and will be assigned a policy that grants them read-only access to S3 buckets. The configuration will include the AWS provider setup, and the IAM user will be created in a specified AWS region. Additionally, an IAM policy will be attached to the user to ensure they have the necessary permissions.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "example_user" {
  name = "example_user"
}

resource "aws_iam_policy" "s3_readonly_policy" {
  name        = "S3ReadOnlyPolicy"
  description = "Policy to provide read-only access to S3 buckets"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:Get*",
          "s3:List*"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "example_user_policy_attachment" {
  user       = aws_iam_user.example_user.name
  policy_arn = aws_iam_policy.s3_readonly_policy.arn
}
```

</iac_template>