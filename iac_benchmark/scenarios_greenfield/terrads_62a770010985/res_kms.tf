data "aws_caller_identity" "current" {}

resource "aws_kms_key" "key" {
  description             = "${var.solution}-${var.env} - General key used to encrypt DBs,password data and S3 objects"
  deletion_window_in_days = 10
  policy                  = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Sid": "Enable IAM policies",
          "Effect": "Allow",
          "Principal": {
            "AWS": ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
           },
          "Action": "kms:*",
          "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.${data.aws_region.current.name}.amazonaws.com"
            },
            "Action": [
                "kms:Encrypt*",
                "kms:Decrypt*",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:Describe*"
            ],
            "Resource": "*",
            "Condition": {
                "ArnEquals": {
                    "kms:EncryptionContext:aws:logs:arn": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"
                }
            }
        },
        {
            "Sid": "Allow CloudFront/VPC Flow logs to use the key to deliver logs",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": [
                "kms:GenerateDataKey*",
                "kms:Decrypt"
            ],
            "Resource": "*"
        },
        {
           "Sid": "Allow service-linked role use of the CMK",
           "Effect": "Allow",
           "Principal": {
               "AWS": [
                   "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
               ]
           },
           "Action": [
               "kms:Encrypt",
               "kms:Decrypt",
               "kms:ReEncrypt*",
               "kms:GenerateDataKey*",
               "kms:DescribeKey"
           ],
           "Resource": "*"
        },
        {
           "Sid": "Allow attachment of persistent resources",
           "Effect": "Allow",
           "Principal": {
               "AWS": [
                   "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
               ]
           },
           "Action": [
               "kms:CreateGrant"
           ],
           "Resource": "*",
           "Condition": {
               "Bool": {
                   "kms:GrantIsForAWSResource": "true"
               }
            }
        },
        {
          "Sid": "Enable IAM policies (For Prod account)",
          "Effect": "Allow",
          "Principal": {
            "AWS": ["arn:aws:iam::${var.prod_account_id}:root"]
           },
          "Action": "kms:*",
          "Resource": "*"
        },
        {
           "Sid": "Allow service-linked role use of the CMK (For Prod account)",
           "Effect": "Allow",
           "Principal": {
               "AWS": [
                   "arn:aws:iam::${var.prod_account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
               ]
           },
           "Action": [
               "kms:Encrypt",
               "kms:Decrypt",
               "kms:ReEncrypt*",
               "kms:GenerateDataKey*",
               "kms:DescribeKey"
           ],
           "Resource": "*"
        },
        {
           "Sid": "Allow attachment of persistent resources (For Prod account)",
           "Effect": "Allow",
           "Principal": {
               "AWS": [
                   "arn:aws:iam::${var.prod_account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
               ]
           },
           "Action": [
               "kms:CreateGrant"
           ],
           "Resource": "*",
           "Condition": {
               "Bool": {
                   "kms:GrantIsForAWSResource": "true"
               }
            }
        }
    ]
}
POLICY

  tags = {
    Name = "${var.solution_short}-${var.env}-kms-key"
  }
}

resource "aws_kms_alias" "key-alias" {
  name          = "alias/${var.solution_short}-${var.env}"
  target_key_id = aws_kms_key.key.key_id
}

data "aws_iam_policy_document" "kms" {
  statement {
    actions   = ["kms:Encrypt", "kms:Decrypt", "kms:GenerateDataKey", "kms:ReEncrypt*", "kms:DescribeKey"]
    resources = [aws_kms_key.key.arn]
  }
}

resource "aws_iam_policy" "kms" {
  name        = "${var.solution_short}-${var.env}-kms"
  path        = "/${var.solution_short}/"
  description = "Policy to use KMS key - ${var.solution} - ${var.env}"
  policy      = data.aws_iam_policy_document.kms.json

  tags = {
    Name = "${var.solution_short}-${var.env}-kms"
  }
}
