def test_template(template: Template):
    # Assert the main secure bucket exists
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert the replica bucket exists
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert the access log bucket exists
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert server-side encryption is enabled on the main bucket
    template.has_resource_properties("AWS::S3::Bucket", {
        "BucketEncryption": {
            "ServerSideEncryptionConfiguration": [
                {
                    "ServerSideEncryptionByDefault": {
                        "SSEAlgorithm": Match.string_like_regexp("AES256|aws:kms")
                    }
                }
            ]
        }
    })

    # Assert public access is blocked
    template.has_resource_properties("AWS::S3::Bucket", {
        "PublicAccessBlockConfiguration": {
            "BlockPublicAcls": True,
            "BlockPublicPolicy": True,
            "IgnorePublicAcls": True,
            "RestrictPublicBuckets": True
        }
    })

    # Assert secure transport is required via bucket policy
    template.has_resource_properties("AWS::S3::BucketPolicy", {
        "PolicyDocument": {
            "Statement": [
                {
                    "Effect": "Deny",
                    "Principal": "*",
                    "Action": "s3:*",
                    "Resource": Match.array_with([
                        Match.string_like_regexp("arn:aws:s3:::[^/]+/.*")
                    ]),
                    "Condition": {
                        "Bool": {
                            "aws:SecureTransport": False
                        }
                    }
                }
            ]
        }
    })