resource "aws_signer_signing_job" "this" {
  region                     = var.region
  profile_name               = var.profile_name
  ignore_signing_job_failure = var.ignore_signing_job_failure

  dynamic "source" {
    for_each = [var.source_config]
    content {
      dynamic "s3" {
        for_each = source.value.s3 != null ? [source.value.s3] : []
        content {
          bucket  = s3.value.bucket
          key     = s3.value.key
          version = s3.value.version
        }
      }
    }
  }

  dynamic "destination" {
    for_each = [var.destination]
    content {
      dynamic "s3" {
        for_each = destination.value.s3 != null ? [destination.value.s3] : []
        content {
          bucket = s3.value.bucket
          prefix = s3.value.prefix
        }
      }
    }
  }
}