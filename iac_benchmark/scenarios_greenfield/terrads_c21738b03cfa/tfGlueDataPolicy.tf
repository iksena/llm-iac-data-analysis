#-----------------------------------------------------------------------------------------
#--- Politica IAM para o Serviço de Ingestão de dados do Glue
#-----------------------------------------------------------------------------------------
data "aws_iam_policy_document" "glue_role_ingestion" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "glue_policy_ingestion" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    resources = [
      "*"
    ]
    actions = [
      "s3:*",
      "secretsmanager:*",
      "cloudwatch:*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "glue:GetTable",
      "glue:*"
    ]
  }
  statement {
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.lake_staging.arn}",
      "${aws_s3_bucket.lake_bronze.arn}",
      "${aws_s3_bucket.lake_silver.arn}"
    ]
    actions = [
      "s3:*",
    ]
  }
}
