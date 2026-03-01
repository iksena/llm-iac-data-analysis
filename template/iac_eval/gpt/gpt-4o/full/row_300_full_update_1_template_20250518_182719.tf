To build the infrastructure for an autograder for a CS class, we will set up a secure environment using AWS resources. The autograder will run students' code stored on GitHub in a controlled environment and store the results in an S3 bucket. The infrastructure will include:

1. **AWS VPC**: A Virtual Private Cloud to host the resources in an isolated network.
2. **AWS Subnet**: A private subnet within the VPC to ensure the autograder does not have internet access.
3. **AWS Security Group**: A security group to control inbound and outbound traffic, ensuring no internet access for the autograder.
4. **AWS S3 Bucket**: A storage bucket to store the results of the autograder.
5. **AWS CodeBuild Project**: A CodeBuild project to run the autograder, configured to pull code from GitHub and execute it within the isolated environment.

The configuration will ensure that the CodeBuild project runs in a private subnet with no internet access, and the results are stored in the S3 bucket.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "autograder_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "autograder_subnet" {
  vpc_id            = aws_vpc.autograder_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = false
}

resource "aws_security_group" "autograder_sg" {
  vpc_id = aws_vpc.autograder_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_s3_bucket" "autograder_results" {
  bucket = "autograder-results-bucket"
  acl    = "private"
}

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-autograder-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.autograder_results.arn,
          "${aws_s3_bucket.autograder_results.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_codebuild_project" "autograder" {
  name          = "autograder-project"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/your-repo/your-project.git"
    git_clone_depth = 1
  }

  vpc_config {
    vpc_id            = aws_vpc.autograder_vpc.id
    subnets           = [aws_subnet.autograder_subnet.id]
    security_group_ids = [aws_security_group.autograder_sg.id]
  }
}
```
</iac_template>

This configuration sets up a secure environment for the autograder, ensuring that the students' code is executed in a private subnet with no internet access, and the results are securely stored in an S3 bucket.