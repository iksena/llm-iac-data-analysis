def test_template(template: Template):
    # Assert Kinesis Data Stream resource exists
    template.resource_count_is("AWS::Kinesis::Stream", 1)

    # Assert the stream has the required properties for real-time ingestion
    template.has_resource_properties("AWS::Kinesis::Stream", {
        "ShardCount": Match.any_value(),
        "RetentionPeriodHours": Match.any_value()
    })

    # Assert CloudWatch alarms for read/write throughput
    template.resource_count_is("AWS::CloudWatch::Alarm", 2)

    # Assert read throughput alarm
    template.has_resource_properties("AWS::CloudWatch::Alarm", {
        "Namespace": "AWS/Kinesis",
        "MetricName": "ReadProvisionedThroughputExceeded",
        "ComparisonOperator": "GreaterThanThreshold",
        "Statistic": "Sum",
        "Period": Match.any_value(),
        "EvaluationPeriods": Match.any_value(),
        "Threshold": Match.any_value(),
        "AlarmActions": Match.any_value()
    })

    # Assert write throughput alarm
    template.has_resource_properties("AWS::CloudWatch::Alarm", {
        "Namespace": "AWS/Kinesis",
        "MetricName": "WriteProvisionedThroughputExceeded",
        "ComparisonOperator": "GreaterThanThreshold",
        "Statistic": "Sum",
        "Period": Match.any_value(),
        "EvaluationPeriods": Match.any_value(),
        "Threshold": Match.any_value(),
        "AlarmActions": Match.any_value()
    })