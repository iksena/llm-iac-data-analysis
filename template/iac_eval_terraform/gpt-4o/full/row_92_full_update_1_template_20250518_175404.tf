To fulfill the business need, we will create a Terraform script that associates an IAM policy with an AWS EKS cluster. The script will define an IAM role that allows access to the EKS cluster, and it will attach a specific policy to this role. The policy will be limited to a specific namespace within the EKS cluster. We will use the AWS provider to manage the resources, and the configuration will include the necessary IAM roles and policies to ensure the EKS cluster can be accessed as required.

The Terraform configuration will include:
1. An AWS provider configuration.
2. An IAM policy with the name "example" that specifies the access permissions.
3. An IAM role that can be assumed by the EKS cluster.
4. An IAM role policy attachment to link the policy to the role.
5. A data source to retrieve the EKS cluster's details.
6. A Kubernetes role binding to associate the IAM role with a specific namespace in the EKS cluster.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "cluster" {
  name = "my-eks-cluster"
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.cluster.name
}

resource "aws_iam_role" "eks_access_role" {
  name = "eks-access-role"

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

resource "aws_iam_policy" "example_policy" {
  name        = "example"
  description = "Policy for EKS access to specific namespace"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kubernetes.io/namespace" = "specific-namespace"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.eks_access_role.name
  policy_arn = aws_iam_policy.example_policy.arn
}

resource "kubernetes_role_binding" "namespace_access" {
  metadata {
    name      = "namespace-access-binding"
    namespace = "specific-namespace"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "namespace-access-role"
  }

  subject {
    kind      = "User"
    name      = aws_iam_role.eks_access_role.name
    api_group = "rbac.authorization.k8s.io"
  }
}
```
</iac_template>