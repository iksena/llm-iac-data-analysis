

resource "aws_kms_key" "sourcekey1" {
    provider                = aws.source1
    description             = "This key is used to encrypt source bucket objects"
    deletion_window_in_days = 10
}

resource "aws_kms_alias" "sourcekey1"  {
    provider      = aws.source1
    name          = "alias/sourcekey1"
    target_key_id = aws_kms_key.sourcekey1.key_id
}


resource "aws_iam_role" "s3replication" {
  provider    = aws.source1
  name_prefix = "s3replication"
  description = "assume the role for the s3 replication"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement" = [
    {
      "Sid" = "s3ReplicationAssume",
      "Effect" = "Allow",
      "Principal" = {
        "Service" = "s3.amazonaws.com"
       },
      "Action" = "sts:AssumeRole"
    },
    ]
    })
}

resource "aws_iam_policy" "s3replication" {
  provider    = aws.source1
  name_prefix = "s3replication"
  description = "Allows replications"

  policy = jsonencode( {
  "Version" = "2012-10-17",
  "Statement" = [
    {
      "Action"= [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket",
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"

      ],
      "Effect" = "Allow",
      "Resource" = [for arn in aws_s3_bucket.source1[*].arn : arn ]
    },
     {
      "Action"= [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket",
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"

      ],
      "Effect" = "Allow",
      "Resource" = [for arn in aws_s3_bucket.source2[*].arn : arn ]
    },
    {
      "Action" = [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl"
      ],
      "Effect"= "Allow",
      "Resource" =  [for arn in aws_s3_bucket.source1[*].arn : "${arn}/*" ]
    },
    {
      "Action" = [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl"
      ],
      "Effect"= "Allow",
      "Resource" =  [for arn in aws_s3_bucket.source2[*].arn : "${arn}/*" ]
    },
    {
      "Action"= [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect"= "Allow",
      "Resource" = [for arn in aws_s3_bucket.replica1[*].arn : "${arn}/*" ]
    },
    {
      "Action"= [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect"= "Allow",
      "Resource" = [for arn in aws_s3_bucket.replica2[*].arn : "${arn}/*" ]
    },
    {
      "Action"= [
        "kms:Decrypt"
      ],
      "Effect" = "Allow",
      "Resource" = [
        aws_kms_key.sourcekey1.arn
      ]
    },
    {
      "Action"= [
        "kms:Decrypt"
      ],
      "Effect" = "Allow",
      "Resource" = [
        aws_kms_key.sourcekey2.arn
      ]
    },
    {
      "Action" = [
        "kms:Encrypt"
      ],
      "Effect" = "Allow",
      "Resource" = [
        aws_kms_key.replicakey1.arn
      ]
    },
    {
      "Action"= [
        "kms:Encrypt"
      ],
      "Effect" = "Allow",
      "Resource" = [
        aws_kms_key.replicakey2.arn
      ]
    }
  ]
}
)

}



resource "aws_iam_policy_attachment" "s3replication" {
  provider   = aws.source1
  name       = "s3replication"
  roles      = [aws_iam_role.s3replication.name]
  policy_arn = aws_iam_policy.s3replication.arn
}


resource "aws_s3_bucket" "source1" {
    count = length(var.s3_bucket_names["source1"])
    provider         = aws.source1
    acl             = "private"
    bucket          = var.s3_bucket_names["source1"][count.index]

    versioning {
        enabled = true
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                kms_master_key_id = aws_kms_key.sourcekey1.arn
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
                    bucket             = aws_s3_bucket.replica1[count.index].arn
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
                    bucket             = aws_s3_bucket.replica2[count.index].arn
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