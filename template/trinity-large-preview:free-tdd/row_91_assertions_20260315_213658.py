def test_template(template: Template):
    # Assert S3 bucket resource exists
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert bucket has AES256 encryption
    template.has_resource_properties("AWS::S3::Bucket", {
        "BucketEncryption": {
            "ServerSideEncryptionConfiguration": [{
                "ServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }]
        }
    })

    # Assert versioning is controlled by parameter
    template.has_resource_properties("AWS::S3::Bucket", {
        "VersioningConfiguration": {
            "Status": Match.string_like_regexp("Enabled|Suspended")
        }
    })

    # Assert lifecycle configuration exists
    template.has_resource_properties("AWS::S3::Bucket", {
        "LifecycleConfiguration": {
            "Rules": Match.array_with({
                "Status": "Enabled",
                "Transitions": Match.array_with({
                    "Days": Match.any_value(),
                    "StorageClass": "GLACIER"
                }),
                "Expiration": {
                    "Days": Match.any_value()
                }
            })
        }
    })

    # Assert bucket policy exists
    template.resource_count_is("AWS::S3::BucketPolicy", 1)

    # Assert bucket policy allows delivery.logs.amazonaws.com to write with bucket-owner-full-control ACL
    template.has_resource_properties("AWS::S3::BucketPolicy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Principal": {
                    "Service": "delivery.logs.amazonaws.com"
                },
                "Action": "s3:PutObject",
                "Resource": Match.string_like_regexp("arn:aws:s3:::"),
                "Condition": {
                    "StringEquals": {
                        "s3:x-amz-acl": "bucket-owner-full-control"
                    }
                }
            })
        }
    })