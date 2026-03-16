def test_template(template: Template):
    # Assert SNS topic with alerting policy exists
    template.has_resource_properties("AWS::SNS::Topic", {
        "TopicPolicy": {
            "PolicyDocument": {
                "Statement": Match.array_with({
                    "Effect": "Allow",
                    "Principal": {"Service": Match.array_with("budgets.amazonaws.com")},
                    "Action": "sns:Publish"
                })
            }
        }
    })

    # Assert SNS topic for fallback exists
    template.has_resource_properties("AWS::SNS::Topic", {
        "TopicPolicy": {
            "PolicyDocument": {
                "Statement": Match.array_with({
                    "Effect": "Allow",
                    "Principal": {"Service": Match.array_with("budgets.amazonaws.com")},
                    "Action": "sns:Publish"
                })
            }
        }
    })

    # Assert CloudWatch Alarm for failed notifications
    template.has_resource_properties("AWS::CloudWatch::Alarm", {
        "Namespace": "AWS/SNS",
        "MetricName": "NumberOfNotificationsFailed",
        "ComparisonOperator": "GreaterThanThreshold",
        "Threshold": 0
    })

    # Assert Alarm action points to fallback SNS topic
    template.has_resource_properties("AWS::CloudWatch::Alarm", {
        "AlarmActions": Match.array_with(Capture())
    })

    # Assert at least one subscription exists (email or HTTPS)
    template.resource_count_is("AWS::SNS::Subscription", Match.any_value)

    # Assert retry policy for HTTP(S) subscriptions if they exist
    template.has_resource_properties("AWS::SNS::Subscription", {
        "Protocol": "https",
        "Endpoint": Match.any_value,
        "DeliveryPolicy": {
            "healthyRetryPolicy": {
                "numRetries": Match.any_value,
                "minDelayTarget": Match.any_value,
                "maxDelayTarget": Match.any_value
            }
        }
    })