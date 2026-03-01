Below is a description of the Terraform program: This configuration creates an AWS IAM role with the name "eks-fargate-profile-example" that can be assumed by the EKS Fargate service ("eks-fargate-pods.amazonaws.com"). The role's trust policy is defined in an assume role policy document. Additionally, the program attaches the predefined AmazonEKSFargatePodExecutionRolePolicy managed policy to the role ensuring it has the necessary permissions. The configuration includes the AWS provider setup with a default region and all resources and variables fully defined.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "eks_fargate_profile" {
  name = "eks-fargate-profile-example"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_fargate_policy_attach" {
  role       = aws_iam_role.eks_fargate_profile.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}
</iac_template>