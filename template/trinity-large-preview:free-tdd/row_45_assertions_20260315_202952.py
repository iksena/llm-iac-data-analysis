def test_template(template: Template):
    # Assert one Kinesis Data Firehose delivery stream exists
    template.resource_count_is("AWS::KinesisFirehose::DeliveryStream", 1)

    # Assert the delivery stream has server-side encryption using AWS Managed keys
    template.has_resource_properties("AWS::KinesisFirehose::DeliveryStream", {
        "DeliveryStreamEncryptionConfigurationInput": {
            "KeyType": "AWS_OWNED_KMS_KEY"
        }
    })

    # Assert the delivery stream has error logging enabled to a CloudWatch log group
    template.has_resource_properties("AWS::KinesisFirehose::DeliveryStream", {
        "ExtendedS3DestinationConfiguration": {
            "ProcessingConfiguration": {
                "Processors": Match.array_with({
                    "Parameters": Match.array_with({
                        "ParameterValueType": "LambdaArn",
                        "ParameterValue": Match.string_like_regexp("arn:aws:lambda:.*")
                    })
                })
            },
            "CloudWatchLoggingOptions": {
                "Enabled": True,
                "LogGroupName": Match.string_like_regexp(".*"),
                "LogStreamName": Match.string_like_regexp(".*")
            }
        }
    })

    # Assert a CloudWatch Log Group exists
    template.resource_count_is("AWS::Logs::LogGroup", 1)

    # Assert a CloudWatch Log Stream exists within the log group
    template.resource_count_is("AWS::Logs::LogStream", 1)