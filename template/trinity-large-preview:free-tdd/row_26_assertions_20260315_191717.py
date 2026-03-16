def test_template(template: Template):
    # Assert S3 bucket exists
    template.resource_count_is("AWS::S3::Bucket", 1)

    # Assert SNS topic exists
    template.resource_count_is("AWS::SNS::Topic", 1)

    # Assert EventBridge rule exists
    template.resource_count_is("AWS::Events::Rule", 1)

    # Assert S3 bucket has EventBridge notification configuration
    template.has_resource_properties("AWS::S3::Bucket", {
        "NotificationConfiguration": {
            "EventBridgeConfiguration": Match.any_value()
        }
    })

    # Assert EventBridge rule targets the SNS topic
    template.has_resource_properties("AWS::Events::Rule", {
        "EventPattern": {
            "detail": {
                "eventName": Match.array_with("ObjectCreated:*")
            }
        },
        "Targets": Match.array_with({
            "Arn": Match.string_like_regexp("arn:aws:sns:.*")
        })
    })