def test_template(template: Template):
    # Assert SQS queue exists
    template.resource_count_is("AWS::SQS::Queue", 1)

    # Assert SNS topic exists
    template.resource_count_is("AWS::SNS::Topic", 1)

    # Assert IoT Rule exists
    template.resource_count_is("AWS::IoT::TopicRule", 1)

    # Assert IoT Rule properties
    template.has_resource_properties("AWS::IoT::TopicRule", {
        "TopicRulePayload": {
            "Sql": Match.string_like_regexp("SELECT \\* FROM 'device/data'"),
            "Actions": Match.array_with({
                "Sns": {
                    "TargetArn": Match.string_like_regexp("arn:aws:sns:")
                }
            })
        }
    })

    # Assert SNS topic is referenced in IoT Rule
    template.has_resource_properties("AWS::IoT::TopicRule", {
        "TopicRulePayload": {
            "Actions": Match.array_with({
                "Sns": {
                    "TargetArn": Capture()
                }
            })
        }
    })

    # Assert SQS queue is created (no specific properties required)
    template.has_resource_properties("AWS::SQS::Queue", {})