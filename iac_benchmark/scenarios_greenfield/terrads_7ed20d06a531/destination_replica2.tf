data "aws_caller_identity" "replica2_bucket_owner" {
    provider = aws.replica2
}

resource "aws_kms_key" "replicakey2" {
    provider                = aws.replica2
    description             = "This key is used to encrypt dest bucket objects"
    deletion_window_in_days = 10
}

resource "aws_kms_alias" "replicakey2"  {
    provider      = aws.replica2
    name          = "alias/replicakey2"
    target_key_id = aws_kms_key.replicakey2.key_id
}

resource "aws_s3_bucket" "replica2" {
    provider         = aws.replica2
    count            = sum([for _, names in var.s3_bucket_names : length(names)])
    acl              = "private"
    bucket           = "${flatten([for _, names in var.s3_bucket_names : names ])[count.index]}-replica2-${data.aws_caller_identity.replica2_bucket_owner.account_id}"

    versioning {
        enabled = true
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                kms_master_key_id = aws_kms_key.replicakey2.arn
                sse_algorithm     = "aws:kms"
            }
        }
    }

    tags = {
        Env = var.env
    }
}