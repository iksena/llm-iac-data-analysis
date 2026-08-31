

resource "aws_kms_key" "sourcekey2" {
    provider                = aws.source2
    description             = "This key is used to encrypt source bucket objects"
    deletion_window_in_days = 10
}

resource "aws_kms_alias" "sourcekey2"  {
    provider      = aws.source2
    name          = "alias/sourcekey2"
    target_key_id = aws_kms_key.sourcekey2.key_id
}

resource "aws_s3_bucket" "source2" {
    count = length(var.s3_bucket_names["source2"])
    provider         = aws.source2
    acl             = "private"
    bucket          = var.s3_bucket_names["source2"][count.index]

    versioning {
        enabled = true
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                kms_master_key_id = aws_kms_key.sourcekey2.arn
                sse_algorithm     = "aws:kms"
            }
        }
    }

    
        replication_configuration {
            role = aws_iam_role.s3replication.arn
            rules {
                id = "test1"
                filter{
                    prefix = ""
                }
                status = "Enabled"
                priority = 1
                destination {
                    bucket             = aws_s3_bucket.replica1[sum([count.index,2])].arn
                    replica_kms_key_id = aws_kms_key.replicakey1.arn
                    storage_class = "STANDARD"
                }
                source_selection_criteria {
                    sse_kms_encrypted_objects {
                        enabled = "true"
                    }
                }
            }
            rules {
                id = "test2"
                priority = 2
                filter{
                    prefix = ""
                }
                status = "Enabled"
                destination {
                    bucket             = aws_s3_bucket.replica2[sum([count.index,2])].arn
                    replica_kms_key_id = aws_kms_key.replicakey2.arn
                    storage_class = "STANDARD"
                }
                source_selection_criteria {
                    sse_kms_encrypted_objects {
                        enabled = "true"
                    }
                }
            }
             
            
        }
    
    tags = {
        Env = var.env
    }
}