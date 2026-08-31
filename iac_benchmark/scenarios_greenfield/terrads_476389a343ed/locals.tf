# https://www.terraform.io/docs/configuration/locals.html

locals {
  name      = "kops-${var.environment}"
  subdomain = format("k8s.%s.%s", var.environment, var.domain)

  # Total number of availability zones required
  az_len = min(
    var.az_count,
    length(data.aws_availability_zones.available.names)
  )

  # A map of common tags that every resource should have
  common_tags = {
    Environment = var.environment
    UUID        = var.uuid
    Owner       = var.owner
    GitURL      = var.git_url
    GitBranch   = var.git_branch
    GitCommit   = var.git_commit
  }

  # A map of regional tags for resources that are not global
  region_tag = {
    Region = var.region
  }
}
