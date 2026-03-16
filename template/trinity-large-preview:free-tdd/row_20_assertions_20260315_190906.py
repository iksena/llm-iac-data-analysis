def test_template(template: Template):
    # Assert CloudWatch Dashboard exists
    template.resource_count_is("AWS::CloudWatch::Dashboard", 1)

    # Assert CloudWatch Logs Insights queries exist
    template.resource_count_is("AWS::Logs::QueryDefinition", 3)

    # Assert Dashboard has expected outputs
    template.has_output(
        "CloudWatchDashboard",
        Match.object_like({
            "Value": Match.string_like_regexp(r"arn:aws:cloudwatch:.*:dashboard/.*")
        })
    )

    # Assert Logs Insights queries have expected outputs
    template.has_output(
        "ConnectionDurationQuery",
        Match.object_like({
            "Value": Match.string_like_regexp(r"arn:aws:logs:.*:query-definition/.*")
        })
    )

    template.has_output(
        "DataTransferQuery",
        Match.object_like({
            "Value": Match.string_like_regexp(r"arn:aws:logs:.*:query-definition/.*")
        })
    )

    template.has_output(
        "UserActivityQuery",
        Match.object_like({
            "Value": Match.string_like_regexp(r"arn:aws:logs:.*:query-definition/.*")
        })
    )