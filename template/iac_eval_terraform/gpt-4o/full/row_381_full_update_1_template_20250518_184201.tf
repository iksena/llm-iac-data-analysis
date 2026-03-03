To address the business need, we will create an AWS S3 Glacier vault and configure AWS Data Lifecycle Manager (DLM) to manage the lifecycle of data stored in the vault. The Terraform configuration will include the creation of an S3 Glacier vault and a DLM lifecycle policy that automates the transition of data to the Glacier vault. We will also set up the necessary IAM roles and policies to allow DLM to access and manage the Glacier vault.

Here's the Terraform configuration:

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_glacier_vault" "example" {
  name = "example-glacier-vault"
}

resource "aws_iam_role" "dlm_role" {
  name = "dlm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "dlm.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "dlm_policy" {
  name        = "dlm-policy"
  description = "Policy for DLM to manage Glacier vault"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "glacier:InitiateJob",
          "glacier:CompleteJob",
          "glacier:AbortJob",
          "glacier:GetJobOutput",
          "glacier:ListJobs",
          "glacier:DeleteArchive",
          "glacier:DescribeVault",
          "glacier:ListVaults",
          "glacier:UploadArchive"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dlm_policy_attach" {
  role       = aws_iam_role.dlm_role.name
  policy_arn = aws_iam_policy.dlm_policy.arn
}

resource "aws_dlm_lifecycle_policy" "glacier_policy" {
  description = "DLM policy for managing Glacier vault"
  execution_role_arn = aws_iam_role.dlm_role.arn
  state = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]
    target_tags = {
      "dlm" = "glacier"
    }

    schedules {
      name = "glacier-schedule"
      create_rule {
        interval      = 24
        interval_unit = "HOURS"
      }

      retain_rule {
        count = 1
      }
    }
  }
}
```

</iac_template>

This configuration sets up an S3 Glacier vault and a DLM lifecycle policy to manage data transitions to the vault. The IAM role and policy allow DLM to perform necessary actions on the Glacier vault.