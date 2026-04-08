#---------------------------------------------------------------
# Custom Karpenter NodePools for P4 and P5 GPU Instances
#---------------------------------------------------------------
# This file adds P4 (A100) and P5 (H100) NodePool configurations
# using the data-addons module pattern for Karpenter resources
#---------------------------------------------------------------

#---------------------------------------------------------------
# Variables
#---------------------------------------------------------------
variable "enable_p4_karpenter" {
  description = "Enable P4 (A100) Karpenter NodePool"
  type        = bool
  default     = true
}

variable "enable_p5_karpenter" {
  description = "Enable P5 (H100) Karpenter NodePool"
  type        = bool
  default     = true
}

#---------------------------------------------------------------
# Custom Karpenter Resources using Data Addons Module
#---------------------------------------------------------------
module "custom_karpenter_resources" {
  source  = "aws-ia/eks-data-addons/aws"
  version = "1.38.0"

  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_karpenter_resources = true
  karpenter_resources_helm_config = {
    p5-gpu-karpenter = var.enable_p5_karpenter ? {
      values = [
        <<-EOT
      name: p5-gpu-karpenter
      clusterName: ${module.eks.cluster_name}
      ec2NodeClass:
        ${indent(2, local.ec2nodeclass)}

      nodePool:
        labels:
          - instanceType: p5-gpu-karpenter
          - type: karpenter
          - accelerator: nvidia
          - gpuType: h100
          - amiFamily: ${var.ami_family}
        taints:
          - key: nvidia.com/gpu
            value: "Exists"
            effect: "NoSchedule"
        requirements:
          - key: "karpenter.k8s.aws/instance-family"
            operator: In
            values: ["p5", "p5e", "p5en"]
          - key: "karpenter.k8s.aws/instance-size"
            operator: In
            values: ["4xlarge", "48xlarge"]
          - key: "kubernetes.io/arch"
            operator: In
            values: ["amd64"]
          - key: "karpenter.sh/capacity-type"
            operator: In
            values: ["on-demand"]
        limits:
          cpu: 1000
          memory: 4000Gi
        disruption:
          consolidationPolicy: WhenEmpty
          consolidateAfter: 300s
          expireAfter: 720h
        weight: 100
      EOT
      ]
    } : null

    p4-gpu-karpenter = var.enable_p4_karpenter ? {
      values = [
        <<-EOT
      name: p4-gpu-karpenter
      clusterName: ${module.eks.cluster_name}
      ec2NodeClass:
        ${indent(2, local.ec2nodeclass)}

      nodePool:
        labels:
          - instanceType: p4-gpu-karpenter
          - type: karpenter
          - accelerator: nvidia
          - gpuType: a100
          - amiFamily: ${var.ami_family}
        taints:
          - key: nvidia.com/gpu
            value: "Exists"
            effect: "NoSchedule"
        requirements:
          - key: "karpenter.k8s.aws/instance-family"
            operator: In
            values: ["p4d", "p4de"]
          - key: "karpenter.k8s.aws/instance-size"
            operator: In
            values: ["24xlarge"]
          - key: "kubernetes.io/arch"
            operator: In
            values: ["amd64"]
          - key: "karpenter.sh/capacity-type"
            operator: In
            values: ["on-demand"]
        limits:
          cpu: 1000
          memory: 3000Gi
        disruption:
          consolidationPolicy: WhenEmpty
          consolidateAfter: 300s
          expireAfter: 720h
        weight: 100
      EOT
      ]
    } : null
  }

  depends_on = [
    module.eks_blueprints_addons,
    module.data_addons
  ]
}

#---------------------------------------------------------------
# Outputs
#---------------------------------------------------------------
output "p5_karpenter_enabled" {
  description = "Whether P5 Karpenter NodePool is enabled"
  value       = var.enable_p5_karpenter
}

output "p4_karpenter_enabled" {
  description = "Whether P4 Karpenter NodePool is enabled"
  value       = var.enable_p4_karpenter
}

output "custom_karpenter_nodepools" {
  description = "List of custom Karpenter NodePools created"
  value = compact([
    var.enable_p5_karpenter ? "p5-gpu-karpenter" : "",
    var.enable_p4_karpenter ? "p4-gpu-karpenter" : ""
  ])
}
