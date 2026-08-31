locals {
  kms_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudWatchToAccessTheKey",
        Effect    = "Allow",
        Principal = { Service = "cloudwatch.amazonaws.com" },
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey",
          "kms:UpdateKeyPolicy",
        ],
        Resource = "*",
      },
      {
        Sid       = "AllowKeyOwnerToUpdate",
        Effect    = "Allow",
        Principal = { AWS = data.aws_caller_identity.current.account_id },
        Action    = "kms:*",
        Resource  = "*",
      },
    ],
  })
  canaries_with_vpc = {
    for canary_key, canary in var.canaries_with_vpc : canary_key => merge(canary, {
      zip_file   = canary.zip_file != null ? canary.zip_file : null
      s3_bucket  = canary.zip_file == null && canary.s3_details != null ? canary.s3_details.s3_bucket : null
      s3_key     = canary.zip_file == null && canary.s3_details != null ? canary.s3_details.s3_key : null
      s3_version = canary.zip_file == null && canary.s3_details != null ? canary.s3_details.s3_version : null
    })
  }
}
