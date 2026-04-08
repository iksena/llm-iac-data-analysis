resource "aws_batch_compute_environment" "this" {
  region      = var.region
  name        = var.name
  name_prefix = var.name_prefix
  type        = var.type
  state       = var.state
  tags        = var.tags

  service_role = var.service_role

  dynamic "compute_resources" {
    for_each = var.compute_resources != null ? [var.compute_resources] : []
    content {
      allocation_strategy = compute_resources.value.allocation_strategy
      bid_percentage      = compute_resources.value.bid_percentage
      desired_vcpus       = compute_resources.value.desired_vcpus
      ec2_key_pair        = compute_resources.value.ec2_key_pair
      image_id            = compute_resources.value.image_id
      instance_role       = compute_resources.value.instance_role
      instance_type       = compute_resources.value.instance_type
      max_vcpus           = compute_resources.value.max_vcpus
      min_vcpus           = compute_resources.value.min_vcpus
      placement_group     = compute_resources.value.placement_group
      security_group_ids  = compute_resources.value.security_group_ids
      spot_iam_fleet_role = compute_resources.value.spot_iam_fleet_role
      subnets             = compute_resources.value.subnets
      tags                = compute_resources.value.tags
      type                = compute_resources.value.type

      dynamic "ec2_configuration" {
        for_each = compute_resources.value.ec2_configuration != null ? compute_resources.value.ec2_configuration : []
        content {
          image_id_override        = ec2_configuration.value.image_id_override
          image_kubernetes_version = ec2_configuration.value.image_kubernetes_version
          image_type               = ec2_configuration.value.image_type
        }
      }

      dynamic "launch_template" {
        for_each = compute_resources.value.launch_template != null ? [compute_resources.value.launch_template] : []
        content {
          launch_template_id   = launch_template.value.launch_template_id
          launch_template_name = launch_template.value.launch_template_name
          version              = launch_template.value.version
        }
      }
    }
  }

  dynamic "eks_configuration" {
    for_each = var.eks_configuration != null ? [var.eks_configuration] : []
    content {
      eks_cluster_arn      = eks_configuration.value.eks_cluster_arn
      kubernetes_namespace = eks_configuration.value.kubernetes_namespace
    }
  }

  dynamic "update_policy" {
    for_each = var.update_policy != null ? [var.update_policy] : []
    content {
      job_execution_timeout_minutes = update_policy.value.job_execution_timeout_minutes
      terminate_jobs_on_update      = update_policy.value.terminate_jobs_on_update
    }
  }
}