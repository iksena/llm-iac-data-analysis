module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.22.0" #ensure to update this to the latest/desired version

  cluster_name      = var.cluster_name
  cluster_endpoint  = var.cluster_endpoint
  cluster_version   = var.cluster_version
  oidc_provider_arn = var.oidc_provider_arn

 eks_addons = {
   aws-ebs-csi-driver = {
     most_recent = true
   }
   coredns = {
     most_recent = true
   }
 }

  observability_tag = null

}