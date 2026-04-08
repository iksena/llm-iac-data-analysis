locals {
  # Validate mutual exclusivity
  validation_check = var.instance_type != null && var.preferred_instance_types != null ? tobool("instance_type and preferred_instance_types are mutually exclusive") : true
}

data "aws_outposts_outpost_instance_type" "this" {
  arn                      = var.arn
  region                   = var.region
  instance_type            = var.instance_type
  preferred_instance_types = var.preferred_instance_types
}