Below is an explanation of the Terraform program that meets your requirements. This configuration deploys an AWS Kendra index using the AWS provider in the us‑east‑1 region. It creates an IAM role that allows the Kendra service to assume the role. The aws_kendra_index resource is defined with a basic name, description, and edition. By omitting any custom document_metadata_configuration_updates blocks, the index uses the default Document Metadata Configuration Updates provided by AWS.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "kendra_index_role" {
  name = "kendra-index-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "kendra.amazonaws.com"
      }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_kendra_index" "default" {
  name        = "example-kendra-index"
  role_arn    = aws_iam_role.kendra_index_role.arn
  edition     = "DEVELOPER_EDITION"
  description = "Kendra index with default Document Metadata Configuration Updates"
  
  // By not specifying any custom document_metadata_configuration_updates,
  // the index will use AWS's default default document metadata configuration.
}
</iac_template>