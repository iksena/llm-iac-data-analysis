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