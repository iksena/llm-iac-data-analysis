locals {
  bucket_name = (var.name_override || local.labels == null) ? var.name : "${local.labels.id}-${var.name}"
  labels      = var.labels
  use_prefix  = var.use_prefix

  roles = var.roles

  groups = var.groups

  sse_config        = var.server_side_encryption_configuration
  acl               = var.acl
  enable_versioning = var.enable_versioning

  public_access_block = var.public_access_block

  config_cors    = var.config_cors
  config_iam     = var.config_iam
  config_logging = var.config_logging

  force_destroy = var.force_destroy
}

locals {
  sid_name = replace(local.bucket_name, "-", "")
}