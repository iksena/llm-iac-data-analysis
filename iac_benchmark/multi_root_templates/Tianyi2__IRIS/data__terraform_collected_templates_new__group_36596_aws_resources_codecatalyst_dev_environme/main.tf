resource "aws_codecatalyst_dev_environment" "this" {
  space_name                 = var.space_name
  project_name               = var.project_name
  instance_type              = var.instance_type
  alias                      = var.alias
  region                     = var.region
  inactivity_timeout_minutes = var.inactivity_timeout_minutes

  dynamic "persistent_storage" {
    for_each = var.persistent_storage
    content {
      size = persistent_storage.value.size
    }
  }

  dynamic "ides" {
    for_each = var.ides
    content {
      name    = ides.value.name
      runtime = ides.value.runtime
    }
  }

  dynamic "repositories" {
    for_each = var.repositories
    content {
      repository_name = repositories.value.repository_name
      branch_name     = repositories.value.branch_name
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}