locals {
  name_conflict_check = var.name != null && var.name_prefix != null ? "error" : "ok"
}

resource "aws_neptune_subnet_group" "this" {
  region      = var.region
  name        = var.name
  name_prefix = var.name_prefix
  description = var.description
  subnet_ids  = var.subnet_ids
  tags        = var.tags

  lifecycle {
    precondition {
      condition     = local.name_conflict_check == "ok"
      error_message = "resource_aws_neptune_subnet_group: name conflicts with name_prefix. Only one can be specified."
    }
  }
}