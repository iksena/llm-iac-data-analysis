To configure an OIDC identity provider for an AWS EKS cluster using Terraform, we will define a Terraform script that sets up the necessary resources. This includes configuring the AWS provider, defining the EKS cluster resource, and setting up the OIDC identity provider configuration. The script will include parameters such as the client ID, identity provider config name, and issuer URL. We will ensure that the EKS cluster is linked by its name attribute, which is set to "example".

The Terraform script will include:
- AWS provider configuration.
- EKS cluster resource with the name "example".
- EKS identity provider configuration with specified client ID, identity provider config name, and issuer URL.

Here is the complete Terraform HCL template:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_eks_cluster" "example" {
  name     = "example"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = ["subnet-0123456789abcdef0", "subnet-abcdef0123456789"]
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eksClusterRole"

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

resource "aws_eks_identity_provider_config" "example_oidc" {
  cluster_name = aws_eks_cluster.example.name

  oidc {
    identity_provider_config_name = "example-oidc"
    issuer_url                   = "https://example.com/oidc"
    client_id                    = "example-client-id"
  }
}

output "eks_cluster_name" {
  value = aws_eks_cluster.example.name
}
```
</iac_template>

This configuration sets up an EKS cluster named "example" and configures an OIDC identity provider with the specified parameters. The IAM role for the EKS cluster is also defined to allow the EKS service to assume the role. The VPC configuration includes placeholder subnet IDs, which should be replaced with actual subnet IDs from your AWS account.