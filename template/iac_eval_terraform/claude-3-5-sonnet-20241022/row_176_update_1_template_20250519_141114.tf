provider "aws" {
  region = "us-west-2"  # You can modify the region as needed
}

# Create SageMaker Code Repository
resource "aws_sagemaker_code_repository" "example" {
  code_repository_name = "terraform-provider-aws-repo"

  git_config {
    repository_url = "https://github.com/hashicorp/terraform-provider-aws.git"
  }

  tags = {
    Name        = "terraform-provider-aws-repo"
    Environment = "development"
    Terraform   = "true"
  }
}

# Output the repository name and ARN
output "code_repository_name" {
  value = aws_sagemaker_code_repository.example.code_repository_name
}

output "code_repository_arn" {
  value = aws_sagemaker_code_repository.example.arn
}