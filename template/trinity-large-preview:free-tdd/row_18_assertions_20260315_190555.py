def test_template(template: Template):
    # Assert one DynamoDB table with stream enabled
    template.resource_count_is("AWS::DynamoDB::Table", 1)
    template.has_resource_properties("AWS::DynamoDB::Table", {
        "StreamSpecification": {
            "StreamEnabled": True,
            "StreamViewType": "NEW_AND_OLD_IMAGES"
        }
    })

    # Assert one EventBridge Pipe
    template.resource_count_is("AWS::Events::Pipe", 1)
    template.has_resource_properties("AWS::Events::Pipe", {
        "Source": {
            "DynamoDBStreamParameters": {
                "StreamArn": Capture()
            }
        },
        "Target": {
            "EventBridgeParameters": {
                "DetailType": Match.any_value(),
                "Source": Match.any_value()
            },
            " Arn": Match.string_like_regexp("arn:aws:events")
        },
        "Enrichment": {
            "Type": "FILTER",
            "Parameters": {
                "InputPath": "$",
                "Filter": {
                    "EventPattern": {
                        "detail": {
                            "NewImage": {
                                "avatarUrl": {
                                    "EndsWith": ".png"
                                }
                            }
                        }
                    }
                }
            }
        }
    })