def test_template(template: Template):
    # Assert the S3 bucket exists with the correct name
    template.has_resource_properties("AWS::S3::Bucket", {
        "BucketName": "ALBAccessLogsBucket"
    })

    # Assert bucket encryption is enabled
    template.has_resource_properties("AWS::S3::Bucket", {
        "BucketEncryption": {
            "ServerSideEncryptionConfiguration": Match.array_with({
                "ServerSideEncryptionByDefault": Match.object_like({
                    "SSEAlgorithm": "AES256"
                })
            })
        }
    })

    # Assert versioning is enabled
    template.has_resource_properties("AWS::S3::Bucket", {
        "VersioningConfiguration": {
            "Status": "Enabled"
        }
    })

    # Assert object lifecycle policy with 90-day expiration
    template.has_resource_properties("AWS::S3::Bucket", {
        "LifecycleConfiguration": {
            "Rules": Match.array_with({
                "Status": "Enabled",
                "ExpirationInDays": 90
            })
        }
    })

    # Assert bucket policy exists
    template.has_resource_properties("AWS::S3::BucketPolicy", {
        "Bucket": "ALBAccessLogsBucket"
    })

    # Assert bucket policy allows ELB accounts to write logs
    template.has_resource_properties("AWS::S3::BucketPolicy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Principal": {
                    "AWS": Match.string_like_regexp("arn:aws:iam::\d{12}:root")
                },
                "Action": "s3:PutObject",
                "Resource": Match.string_like_regexp("arn:aws:s3:::ALBAccessLogsBucket/.*")
            })
        }
    })

    # Assert bucket policy allows delivery.logs.amazonaws.com to write logs
    template.has_resource_properties("AWS::S3::BucketPolicy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Principal": {
                    "Service": "delivery.logs.amazonaws.com"
                },
                "Action": "s3:PutObject",
                "Resource": Match.string_like_regexp("arn:aws:s3:::ALBAccessLogsBucket/.*")
            })
        }
    })

    # Assert bucket policy allows delivery.logs.amazonaws.com to get bucket ACL
    template.has_resource_properties("AWS::S3::BucketPolicy", {
        "PolicyDocument": {
            "Statement": Match.array_with({
                "Effect": "Allow",
                "Principal": {
                    "Service": "delivery.logs.amazonaws.com"
                },
                "Action": "s3:GetBucketAcl",
                "Resource": "ALBAccessLogsBucket"
            })
        }
    })

    # Assert bucket is private (Block Public Access settings)
    template.has_resource_properties("AWS::S3::Bucket", {
        "PublicAccessBlockConfiguration": {
            "BlockPublicAcls": True,
            "BlockPublicPolicy": True,
            "IgnorePublicAcls": True,
            "RestrictPublicBuckets": True
        }
    })

    # Assert bucket ownership is enforced
    template.has_resource_properties("AWS::S3::Bucket", {
        "OwnershipControls": {
            "Rules": Match.array_with({
                "ObjectOwnership": "BucketOwnerEnforced"
            })
        }
    })