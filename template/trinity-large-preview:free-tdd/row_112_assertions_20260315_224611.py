def test_template(template: Template):
    # Assert one S3 bucket exists
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert one SQS queue exists
    template.resource_count_is("AWS::SQS::Queue", 1)

    # Assert S3 bucket has notification configuration for object creation events
    template.has_resource_properties("AWS::S3::Bucket", {
        "NotificationConfiguration": {
            "QueueConfigurations": [{
                "Events": ["s3:ObjectCreated:*"]
            }]
        }
    })