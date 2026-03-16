def test_template(template: Template):
    # Assert recovery cluster creation
    template.has_resource_properties(
        "AWS::Route53RecoveryCluster::Cluster",
        {
            "Name": Match.string_like_regexp(".*")
        }
    )

    # Assert control panel creation
    template.has_resource_properties(
        "AWS::Route53RecoveryControl::ControlPanel",
        {
            "Name": Match.string_like_regexp(".*"),
            "ClusterArn": Match.string_like_regexp("arn:aws:route53-recovery-cluster:.*")
        }
    )

    # Assert routing controls for two regions
    routing_controls = template.find_resources(
        "AWS::Route53RecoveryControl::RoutingControl",
        {
            "ControlPanelArn": Match.string_like_regexp("arn:aws:route53-recovery-control:.*")
        }
    )
    assert len(routing_controls) == 2

    # Assert safety rule for at least one active region
    template.has_resource_properties(
        "AWS::Route53RecoveryControl::SafetyRule",
        {
            "Name": Match.string_like_regexp(".*"),
            "RuleConfig": {
                "Inverted": False,
                "Threshold": 1,
                "Type": "ATLEAST"
            },
            "SafetyRuleType": "AVAILABILITY",
            "WaitPeriodMs": Match.any_value()
        }
    )

    # Assert health checks linked to routing controls
    template.has_resource_properties(
        "AWS::Route53RecoveryHealthCheck::HealthCheck",
        {
            "HealthCheckConfig": {
                "Port": Match.any_value(),
                "Type": Match.string_like_regexp("HTTP|HTTPS|TCP"),
                "ResourcePath": Match.string_like_regexp(".*")
            },
            "Tags": Match.array_with(
                Match.object_like({
                    "Key": "routingControlArn",
                    "Value": Match.string_like_regexp("arn:aws:route53-recovery-control:.*")
                })
            )
        }
    )