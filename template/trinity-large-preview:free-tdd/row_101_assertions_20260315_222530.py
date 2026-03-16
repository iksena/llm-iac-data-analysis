def test_template(template: Template):
    # Assert VPC with Flow Logs
    template.has_resource_properties("AWS::EC2::VPC", {
        "EnableDnsSupport": True,
        "EnableDnsHostnames": True
    })

    # Assert Flow Log resource exists
    template.has_resource_properties("AWS::EC2::FlowLog", {
        "ResourceType": "VPC",
        "TrafficType": Match.any_value(),
        "LogDestinationType": "s3",
        "LogDestination": Match.string_like_regexp("arn:aws:s3:::.+")
    })

    # Assert S3 bucket for flow logs
    template.has_resource_properties("AWS::S3::Bucket", {
        "PublicAccessBlockConfiguration": {
            "BlockPublicAcls": True,
            "BlockPublicPolicy": True,
            "IgnorePublicAcls": True,
            "RestrictPublicBuckets": True
        },
        "BucketEncryption": {
            "ServerSideEncryptionConfiguration": [{
                "ServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }]
        },
        "VersioningConfiguration": {
            "Status": "Enabled"
        }
    })

    # Assert S3 bucket policy for log delivery
    template.has_resource_properties("AWS::S3::BucketPolicy", {
        "PolicyDocument": {
            "Statement": Match.array_with([{
                "Effect": "Allow",
                "Principal": {
                    "Service": "delivery.logs.amazonaws.com"
                },
                "Action": "s3:PutObject",
                "Resource": Match.string_like_regexp("arn:aws:s3:::.+/AWSLogs/.+/.*")
            }])
        }
    })

    # Assert optional log file prefix
    template.has_resource_properties("AWS::S3::Bucket", {
        "LoggingConfiguration": Match.any_value()
    })

    # Assert output for bucket name
    template.has_output("FlowLogBucketName", {
        "Value": Match.string_like_regexp("arn:aws:s3:::.+")
    })