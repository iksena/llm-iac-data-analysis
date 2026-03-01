The Terraform configuration will provision an AWS IAM role specifically for an Amazon EKS cluster. The role will have the name "example" and will include an assume role policy that allows EKS services to assume the role. The AmazonEKSClusterPolicy will be attached to this role to provide the necessary permissions. Additionally, an AWS EKS cluster named "example" will be created. This cluster will be associated with a VPC and a subnet. The EKS cluster will have its endpoint private access set to false and public access set to true. Proper dependency handling will ensure that the IAM role and its policy attachment are completed before the EKS cluster is created.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_iam_role" "example" {
  name = "example"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.example.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "example" {
  name     = "example"
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids         = [aws_subnet.example.id]
    endpoint_private_access = false
    endpoint_public_access  = true
  }

  depends_on = [aws_iam_role_policy_attachment.example]
}
```
</iac_template>