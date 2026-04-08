resource "aws_codegurureviewer_repository_association" "this" {
  dynamic "repository" {
    for_each = var.repository_bitbucket != null ? [var.repository_bitbucket] : []
    content {
      bitbucket {
        connection_arn = repository.value.connection_arn
        name           = repository.value.name
        owner          = repository.value.owner
      }
    }
  }

  dynamic "repository" {
    for_each = var.repository_codecommit != null ? [var.repository_codecommit] : []
    content {
      codecommit {
        name = repository.value.name
      }
    }
  }

  dynamic "repository" {
    for_each = var.repository_github_enterprise_server != null ? [var.repository_github_enterprise_server] : []
    content {
      github_enterprise_server {
        connection_arn = repository.value.connection_arn
        name           = repository.value.name
        owner          = repository.value.owner
      }
    }
  }

  dynamic "repository" {
    for_each = var.repository_s3_bucket != null ? [var.repository_s3_bucket] : []
    content {
      s3_bucket {
        bucket_name = repository.value.bucket_name
        name        = repository.value.name
      }
    }
  }

  dynamic "kms_key_details" {
    for_each = var.kms_key_details != null ? [var.kms_key_details] : []
    content {
      encryption_option = kms_key_details.value.encryption_option
      kms_key_id        = kms_key_details.value.kms_key_id
    }
  }

  region = var.region

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}