To fulfill the business need, we will create a Terraform configuration that adds an addon to an existing AWS EKS cluster. The addon we will add is the "vpc-cni" addon, which is commonly used for networking in EKS clusters. We will define the necessary resources, including the EKS cluster and the addon configuration. The configuration will include the AWS provider setup, and we will assume that the EKS cluster already exists with a specified name.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_eks_addon" "example" {
  cluster_name = "my-eks-cluster"  # Replace with your actual EKS cluster name
  addon_name   = "vpc-cni"

  # Optional: Specify the addon version if needed
  # addon_version = "v1.7.5-eksbuild.1"

  # Optional: Specify the service account role ARN if needed
  # service_account_role_arn = "arn:aws:iam::123456789012:role/your-service-account-role"

  # Optional: Tags for the addon
  tags = {
    Name = "example-addon"
  }
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"  # Replace with your actual EKS cluster name
}
```
</iac_template>

This Terraform configuration sets up the AWS provider in the "us-west-2" region and defines an `aws_eks_addon` resource to add the "vpc-cni" addon to an existing EKS cluster. The cluster name is specified in the `cluster_name` variable, which has a default value of "my-eks-cluster". You can replace this with the actual name of your EKS cluster. Optional parameters such as `addon_version` and `service_account_role_arn` can be specified if needed.