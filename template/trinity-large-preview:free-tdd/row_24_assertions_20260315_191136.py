def test_template(template: Template):
    # VPC
    template.resource_count_is("AWS::EC2::VPC", 1)

    # Two subnets
    template.resource_count_is("AWS::EC2::Subnet", 2)

    # Auto Scaling Group
    template.resource_count_is("AWS::AutoScaling::AutoScalingGroup", 1)

    # Instances must have Internet access
    template.has_resource_properties("AWS::EC2::Instance", {
        "NetworkInterfaces": Match.array_with({
            "AssociatePublicIpAddress": True
        })
    })

    # ElastiCache with automated snapshot management and failover
    template.has_resource_properties("AWS::ElastiCache::CacheCluster", {
        "SnapshotRetentionLimit": Match.any_value(),
        "SnapshotWindow": Match.any_value(),
        "AutoMinorVersionUpgrade": True,
        "PreferredMaintenanceWindow": Match.any_value(),
        "NotificationTopicArn": Match.any_value(),
        "CacheNodeType": "cache.m3.medium",
        "AZMode": "cross-az"
    })

    # Lambda function and IAM role for dynamic snapshotting
    template.resource_count_is("AWS::Lambda::Function", 1)
    template.resource_count_is("AWS::IAM::Role", 1)

    # Regional AZ mappings for subnet placement
    template.has_resource_properties("AWS::EC2::Subnet", {
        "AvailabilityZone": Match.string_like_regexp("^[a-zA-Z0-9-]+$")
    })