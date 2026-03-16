def test_template(template: Template):
    # Assert SNS topic exists
    template.resource_count_is("AWS::SNS::Topic", 1)

    # Assert SQS queues exist
    template.resource_count_is("AWS::SQS::Queue", 4)  # 3 main queues + 1 DLQ

    # Assert AllMetricsSqsQueue exists
    template.has_resource_properties("AWS::SQS::Queue", {
        "QueueName": Match.string_like_regexp("AllMetricsSqsQueue")
    })

    # Assert TemperatureSqsQueue exists
    template.has_resource_properties("AWS::SQS::Queue", {
        "QueueName": Match.string_like_regexp("TemperatureSqsQueue")
    })

    # Assert HumiditySqsQueue exists
    template.has_resource_properties("AWS::SQS::Queue", {
        "QueueName": Match.string_like_regexp("HumiditySqsQueue")
    })

    # Assert DLQ exists
    template.has_resource_properties("AWS::SQS::Queue", {
        "QueueName": Match.string_like_regexp(".*DLQ")
    })

    # Assert SNS subscription for AllMetricsSqsQueue
    template.has_resource_properties("AWS::SNS::Subscription", {
        "Protocol": "sqs",
        "Endpoint": Match.string_like_regexp("arn:aws:sqs:.*:.*:AllMetricsSqsQueue")
    })

    # Assert SNS subscription for TemperatureSqsQueue with filter policy
    template.has_resource_properties("AWS::SNS::Subscription", {
        "Protocol": "sqs",
        "Endpoint": Match.string_like_regexp("arn:aws:sqs:.*:.*:TemperatureSqsQueue"),
        "FilterPolicy": {
            "MetricType": ["Temperature"]
        }
    })

    # Assert SNS subscription for HumiditySqsQueue with filter policy
    template.has_resource_properties("AWS::SNS::Subscription", {
        "Protocol": "sqs",
        "Endpoint": Match.string_like_regexp("arn:aws:sqs:.*:.*:HumiditySqsQueue"),
        "FilterPolicy": {
            "MetricType": ["Humidity"]
        }
    })