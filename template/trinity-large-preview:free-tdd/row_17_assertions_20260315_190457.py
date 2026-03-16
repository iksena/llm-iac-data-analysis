def test_template(template: Template):
    # Assert SNS Topic exists
    template.resource_count_is("AWS::SNS::Topic", 1)

    # Assert CloudWatch Alarms exist (4 total)
    template.resource_count_is("AWS::CloudWatch::Alarm", 4)

    # Assert Alarms have correct metric and thresholds
    alarms = template.find_resources("AWS::CloudWatch::Alarm")
    thresholds = [5, 10, 20, 40]
    for threshold in thresholds:
        alarm_name = f"MonthlyCostAlarm-{threshold}"
        template.has_resource_properties("AWS::CloudWatch::Alarm", {
            "AlarmName": Match.string_like_regexp(f"{alarm_name}"),
            "Namespace": "AWS/Billing",
            "MetricName": "EstimatedCharges",
            "Statistic": "Maximum",
            "Period": 21600,  # 6 hours in seconds
            "EvaluationPeriods": 1,
            "Threshold": threshold,
            "ComparisonOperator": "GreaterThanThreshold",
            "TreatMissingData": "breaching",
            "AlarmActions": Match.array_with(Match.string_like_regexp("arn:aws:sns:"))
        })

    # Assert SNS Topic has email subscription
    template.has_resource_properties("AWS::SNS::Topic", {
        "Subscription": Match.array_with({
            "Endpoint": "xxxxx@gmail.com",
            "Protocol": "email"
        })
    })

    # Assert Alarms reference the SNS Topic
    for threshold in thresholds:
        alarm_name = f"MonthlyCostAlarm-{threshold}"
        template.has_resource_properties("AWS::CloudWatch::Alarm", {
            "AlarmName": Match.string_like_regexp(f"{alarm_name}"),
            "AlarmActions": Match.array_with(Match.string_like_regexp("arn:aws:sns:"))
        })