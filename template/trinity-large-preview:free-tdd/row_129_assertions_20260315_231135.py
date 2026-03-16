def test_template(template: Template):
    # Assert S3 bucket for Config snapshots
    template.resource_count_is("AWS::S3::Bucket", 1)
    template.has_resource_properties("AWS::S3::Bucket", {
        "VersioningConfiguration": {"Status": "Enabled"},
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
        }
    })

    # Assert SNS topic for notifications
    template.resource_count_is("AWS::SNS::Topic", 1)

    # Assert AWS Config Recorder with global coverage
    template.resource_count_is("AWS::Config::ConfigurationRecorder", 1)
    template.has_resource_properties("AWS::Config::ConfigurationRecorder", {
        "RecordingGroup": {
            "AllSupported": True,
            "IncludeGlobalResourceTypes": True
        }
    })

    # Assert Config Delivery Channel with S3 and SNS
    template.resource_count_is("AWS::Config::DeliveryChannel", 1)
    template.has_resource_properties("AWS::Config::DeliveryChannel", {
        "ConfigSnapshotDeliveryProperties": {
            "DeliveryFrequency": Match.string_like_regexp(r"(One_Hour|Three_Hours|Six_Hours|Twelve_Hours|TwentyFour_Hours)")
        }
    })

    # Assert Lambda function for retention management
    template.resource_count_is("AWS::Lambda::Function", 1)

    # Assert custom resource for retention period management
    template.resource_count_is("AWS::CloudFormation::CustomResource", 1)
    template.has_resource_properties("AWS::CloudFormation::CustomResource", {
        "ServiceToken": Match.string_like_regexp(r"arn:aws:lambda:")
    })

    # Assert retention period default (2557 days)
    template.has_resource_properties("AWS::CloudFormation::CustomResource", {
        "ServiceToken": Match.any_value(),
        "RetentionPeriod": 2557
    })