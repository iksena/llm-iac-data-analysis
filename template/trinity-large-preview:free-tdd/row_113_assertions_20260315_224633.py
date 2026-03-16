def test_template(template: Template):
    # Assert SNS topic exists
    template.resource_count_is("AWS::SNS::Topic", 1)

    # Assert EventBridge rule exists
    template.resource_count_is("AWS::Events::Rule", 1)

    # Assert EventBridge rule targets SNS topic
    template.has_resource_properties("AWS::Events::Rule", {
        "EventPattern": Match.object_like({
            "source": ["demo.cli"]
        }),
        "Targets": Match.array_with([Match.object_like({
            "Arn": Match.string_like_regexp("arn:aws:sns:.*")
        })])
    })

    # Assert SNS topic policy grants EventBridge permissions
    template.has_resource_properties("AWS::SNS::TopicPolicy", {
        "PolicyDocument": Match.object_like({
            "Statement": Match.array_with([Match.object_like({
                "Effect": "Allow",
                "Principal": Match.object_like({
                    "Service": "events.amazonaws.com"
                }),
                "Action": "sns:Publish"
            })])
        })
    })